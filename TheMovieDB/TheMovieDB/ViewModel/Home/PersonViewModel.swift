//
//  PersonViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class PersonViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Data Bindings
    
    var biography = Observable<String?>(nil)
    var birthday = Observable<String?>(nil)
    var placeOfBirth = Observable<String?>(nil)
    var alsoKnownAs = Observable<String?>(nil)
    var photo = Observable<UIImage?>(nil)
    
    var isFacebookEnabled = Observable<Bool>(false)
    var isInstagramEnabled = Observable<Bool>(false)
    var isTwitterEnabled = Observable<Bool>(false)
    
    var facebookTintColor = Observable<UIColor>(UIColor.darkGray)
    var instagramTintColor = Observable<UIColor>(UIColor.darkGray)
    var twitterTintColor = Observable<UIColor>(UIColor.darkGray)
    
    // MARK: Variables
    private var idPerson: Int?
    
    // MARK: Objects
    private var person: Person? {
        didSet {
            let emptyString = "-"
            
            biography.value = person?.biography ?? emptyString
            birthday.value = person?.birthday ?? emptyString
            placeOfBirth.value = person?.placeOfBirth ?? emptyString
            alsoKnownAs.value = person?.alsoKnownAs?.first ?? emptyString
            
            loadImageData()
            
            delegate?.reloadData?()
        }
    }
    
    private var externalIds: ExternalIds? {
        didSet {
            isFacebookEnabled.value = externalIds?.facebookId != nil
            isInstagramEnabled.value = externalIds?.instagramId != nil
            isTwitterEnabled.value = externalIds?.twitterId != nil
            
            facebookTintColor.value = externalIds?.facebookId != nil ? HexColor.text.color: UIColor.darkGray
            instagramTintColor.value = externalIds?.instagramId != nil ? HexColor.text.color: UIColor.darkGray
            twitterTintColor.value = externalIds?.twitterId != nil ? HexColor.text.color: UIColor.darkGray
        }
    }
    
    // MARK: Cast
    private var castList = [Cast]() { didSet { delegate?.reloadData?() } }
    var numberOfCastMovies: Int { return castList.count }

    // MARK: Photos
    private var imagesList = [PersonImage]() { didSet { setupPhotos() } }
    private var photos = [Photo]()

    // MARK: Service Model
    let serviceModel = PersonServiceModel()
    
    // MARK: Life Cycle
    
    init(_ object: Int?) {
        self.idPerson = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {        
        getPerson()
        getMovieCredits()
        getExternalIds()
        getImages()
    }
    
    private func getPerson() {
        if person != nil { return }

        Loading.shared.startLoading()
        serviceModel.getPerson(from: idPerson, requestUrl: .person) { [weak self] (object) in
            Loading.shared.stopLoading()
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.person = object as? Person
        }
    }
    
    private func getMovieCredits() {
        guard castList.isEmpty else {
            return
        }

        serviceModel.getPerson(from: idPerson, requestUrl: .personMovieCredits) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? CreditsList, let results = object.cast else {
                return
            }
            
            strongSelf.castList.append(contentsOf: results)
        }
    }
    
    private func getExternalIds() {
        if externalIds != nil { return }

        serviceModel.getPerson(from: idPerson, requestUrl: .personExternalIds) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.externalIds = object as? ExternalIds
        }
    }

    private func getImages() {
        guard imagesList.isEmpty else {
            return
        }

        serviceModel.getImages(from: idPerson) { [weak self] (object) in
            guard let strongSelf = self else {
                return
            }
            guard let object = object as? PersonImagesList, let results = object.results else {
                return
            }
            strongSelf.imagesList = results
        }
    }
    
    private func loadImageData() {
        if photo.value != nil { return }

        serviceModel.loadImage(path: person?.profilePath ?? "", handlerData: { [weak self] (data) in
            guard let strongSelf = self, let data = data as? Data else {
                return
            }

            strongSelf.photo.value = UIImage(data: data)
        })
    }
    
    func loadMovieImageData(at index: Int, handlerData: @escaping HandlerObject) {
        serviceModel.loadImage(path: castList[index].posterPath, handlerData: handlerData)
    }
    
    // MARK: - View Model -
    
    var personName: String? {
        return person?.name
    }
    
    func open(socialMediaType: SocialMediaType) {
        SocialMedia.shared.open(mediaType: socialMediaType, userId: externalId(with: socialMediaType))
    }
    
    private func externalId(with socialMediaType: SocialMediaType) -> String? {
        switch socialMediaType {
        case .facebook:
            return externalIds?.facebookId
        case .instagram:
            return externalIds?.instagramId
        case .twitter:
            return externalIds?.twitterId
        }
    }
    
    func movieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        let cast = castList[index]
        let dictionary: [String:Any?] = ["id": cast.id, "original_title": cast.originalTitle]
        let movie = Movie(object: dictionary)
        return MovieDetailViewModel(movie)
    }

    // MARK: - Photos -

    func presentPhotos() {
        if photos.isEmpty  { return }
        PhotosComponent.present(photos: photos)
    }

    func setupPhotos() {
        photos = [Photo]()
        for image in imagesList {
            serviceModel.loadImage(path: image.filePath) { [weak self] (data) in
                guard let strongSelf = self else {
                    return
                }
                
                if let data = data as? Data {
                    strongSelf.photos.append(Photo(image: UIImage(data: data)))
                }
            }
        }
    }
}
