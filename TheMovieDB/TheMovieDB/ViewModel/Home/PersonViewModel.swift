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
    var photo = Observable<UIImage?>(nil)
    
    // MARK: Variables
    private var idPerson: Int?
    
    // MARK: Objects
    private var person: Person? {
        didSet {
            biography.value = person?.biography ?? ""
            loadImageData()
            delegate?.reloadData()
        }
    }
    
    // MARK: Cast
    private var castList = [Cast]() { didSet { delegate?.reloadData() } }
    var numberOfCastMovies: Int { return castList.count }
    
    // MARK: Personal Info
    enum PersonalInfo: String {
        case birthday = "Birthday"
        case placeOfBirth = "Place of birth"
        case alsoKnownAs = "Also known as"
        
        static func personalInfo(at index: Int) -> PersonalInfo? {
            switch index {
                case 0: return PersonalInfo.birthday
                case 1: return PersonalInfo.placeOfBirth
                case 2: return PersonalInfo.alsoKnownAs
                default: return nil
            }
        }
    }
    
    private var personalInfo: [PersonalInfo] = [.birthday, .placeOfBirth, .alsoKnownAs]
    var numberOfPersonalInfo: Int { return personalInfo.count }
    
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
    
    func personalInfoTitle(at indexPath: IndexPath) -> String? {
        if let personalInfo = PersonalInfo.personalInfo(at: indexPath.row) {
            return personalInfo.rawValue
        }
        return nil
    }
    
    func personalInfoDescription(at indexPath: IndexPath) -> String? {
        if let personalInfo = PersonalInfo.personalInfo(at: indexPath.row) {
            switch personalInfo {
                case .birthday: return person?.birthday
                case .placeOfBirth: return person?.placeOfBirth
                case .alsoKnownAs: return person?.alsoKnownAs?.first
            }
        }
        return nil
    }
    
    func heightForPersonalInfo(at indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0, spacing: CGFloat = 8
        
        if let string = personalInfoTitle(at: indexPath) {
            height += string.height + spacing
        }
        
        if let string = personalInfoDescription(at: indexPath) {
            height += string.height + spacing
        }
        
        return height
    }    
}
