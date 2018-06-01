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
    
    var isFacebookEnabled = Observable<Bool>(false)
    var isInstagramEnabled = Observable<Bool>(false)
    var isTwitterEnabled = Observable<Bool>(false)
    
    var facebookTintColor = Observable<UIColor>(UIColor.darkGray)
    var instagramTintColor = Observable<UIColor>(UIColor.darkGray)
    var twitterTintColor = Observable<UIColor>(UIColor.darkGray)
    
    // MARK: Variables
    private var idPerson: Int?
    
    var imageUrl: URL? {
        return URL(string: serviceModel.imageUrl(with: person?.profilePath ?? ""))
    }
    
    // MARK: Objects
    private var person: Person? {
        didSet {
            let emptyString = "-"
            
            biography.value = person?.biography ?? emptyString
            birthday.value = person?.birthday ?? emptyString
            placeOfBirth.value = person?.placeOfBirth ?? emptyString
            alsoKnownAs.value = person?.alsoKnownAs?.first ?? emptyString
            
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
    private var arrayCast = [Cast]() { didSet { delegate?.reloadData?() } }
    var numberOfCastMovies: Int { return arrayCast.count }

    // MARK: Photos
    private var arrayImages = [PersonImage]() { didSet { setupPhotos() } }
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

        Loading.shared.start()
        serviceModel.getPerson(from: idPerson, requestUrl: .person) { [weak self] (object) in
            Loading.shared.stop()
            self?.person = object as? Person
        }
    }
    
    private func getMovieCredits() {
        guard arrayCast.isEmpty else {
            return
        }

        serviceModel.getPerson(from: idPerson, requestUrl: .personMovieCredits) { [weak self] (object) in
            guard let object = object as? CreditsList, let results = object.cast else {
                return
            }
            
            self?.arrayCast.append(contentsOf: results)
        }
    }
    
    private func getExternalIds() {
        if externalIds != nil { return }

        serviceModel.getPerson(from: idPerson, requestUrl: .personExternalIds) { [weak self] (object) in
            self?.externalIds = object as? ExternalIds
        }
    }

    private func getImages() {
        guard arrayImages.isEmpty else {
            return
        }

        serviceModel.getImages(from: idPerson) { [weak self] (object) in
            guard let results = object.results else {
                return
            }
            self?.arrayImages = results
        }
    }
    
    func movieImageUrl(at index: Int) -> URL? {
        return URL(string: serviceModel.imageUrl(with: arrayCast[index].posterPath ?? ""))
    }
    
    // MARK: - View Model -
    
    var personName: String? {
        return person?.name
    }
    
    func open(socialMediaType: SocialMediaType) {
        SocialMedia.open(mediaType: socialMediaType, id: externalId(with: socialMediaType))
    }
    
    private func externalId(with socialMediaType: SocialMediaType) -> String? {
        switch socialMediaType {
        case .facebook:
            return externalIds?.facebookId
        case .instagram:
            return externalIds?.instagramId
        case .twitter:
            return externalIds?.twitterId
        default:
            return nil
        }
    }
    
    func movieDetailViewModel(at index: Int) -> MovieDetailViewModel? {
        let cast = arrayCast[index]
        let dictionary: [String: Any?] = [
            "id": cast.id,
            "original_title": cast.originalTitle,
            "language": Locale.preferredLanguages.first ?? ""
        ]
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
        for image in arrayImages {
            serviceModel.loadImage(path: image.filePath) { [weak self] (data) in
                guard let data = data as? Data else {
                    return
                }
                
                self?.photos.append(Photo(image: UIImage(data: data)))
            }
        }
    }
}
