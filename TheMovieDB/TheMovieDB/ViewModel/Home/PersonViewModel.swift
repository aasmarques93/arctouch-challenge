//
//  PersonViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

protocol PersonViewModelDelegate: class {
    func reloadData()
}

class PersonViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: PersonViewModelDelegate?
    
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
            delegate?.reloadData()
        }
    }
    
    private var externalIds: ExternalIds? {
        didSet {
            isFacebookEnabled.value = externalIds?.facebookId != nil
            isInstagramEnabled.value = externalIds?.instagramId != nil
            isTwitterEnabled.value = externalIds?.twitterId != nil
            
            facebookTintColor.value = externalIds?.facebookId != nil ? HexColor.text.color : UIColor.darkGray
            instagramTintColor.value = externalIds?.instagramId != nil ? HexColor.text.color : UIColor.darkGray
            twitterTintColor.value = externalIds?.twitterId != nil ? HexColor.text.color : UIColor.darkGray
        }
    }
    
    // MARK: Cast
    private var castList = [Cast]() { didSet { delegate?.reloadData() } }
    var numberOfCastMovies: Int { return castList.count }
    
    // MARK: Service Model
    let serviceModel = PersonServiceModel()
    
    // MARK: Life Cycle
    
    init(_ object: Int?) {
        super.init()
        self.idPerson = object
    }
    
    // MARK: - Service requests -
    
    func loadData() {
        getPerson()
        getMovieCredits()
        getExternalIds()
    }
    
    private func getPerson() {
        loadingView.startInWindow()
        serviceModel.getPerson(type: Person.self, from: idPerson, requestUrl: .person) { (object) in
            self.loadingView.stop()
            self.person = object as? Person
        }
    }
    
    private func getMovieCredits() {
        serviceModel.getPerson(type: CreditsList.self, from: idPerson, requestUrl: .personMovieCredits) { (object) in
            if let object = object as? CreditsList, let results = object.cast {
                self.castList.append(contentsOf: results)
            }
        }
    }
    
    private func getExternalIds() {
        serviceModel.getPerson(type: ExternalIds.self, from: idPerson, requestUrl: .personExternalIds) { (object) in
            self.externalIds = object as? ExternalIds
        }
    }
    
    private func loadImageData() {
        serviceModel.loadImage(path: person?.profilePath ?? "", handlerData: { (data) in
            if let data = data as? Data { self.photo.value = UIImage(data: data) }
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
}
