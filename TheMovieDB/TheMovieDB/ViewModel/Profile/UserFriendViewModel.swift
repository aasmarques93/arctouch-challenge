//
//  UserFriendViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class UserFriendViewModel: ViewModel {
    // MARK: - Properties -
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Service Model
    private let serviceModel = UserFriendsServiceModel()
    private let tvShowDetailServiceModel = TVShowDetailServiceModel()
    
    // MARK: Observables
    var isMessageErrorHidden = Observable<Bool>(false)
    
    var name = Observable<String?>(nil)
    var email = Observable<String?>(nil)
    var personality = Observable<String?>(nil)
    var movieShow = Observable<String?>(nil)
    
    // MARK: Objects
    private var userFriend: User
    private var userDetail: User? {
        didSet {
            getShowTrackDetail()
            personality.value = userDetail?.personality?.title
        }
    }
    private var tvShowDetail: TVShowDetail? {
        didSet {
            movieShow.value = tvShowDetail?.name
        }
    }

    private var arrayYourListSections: [YourListSection] = [.wantToSeeMovies, .tvShowsTrack, .seenMovies]
    var numberYourListSections: Int { return arrayYourListSections.count }

    // MARK: Variables
    var imageUrl: URL? {
        guard let url = userFriend.picture?.data?.url else {
            return nil
        }
        return URL(string: serviceModel.imageUrl(with: url, environmentBase: .custom))
    }
    
    // MARK: - Life cycle -
    
    init(object: User) {
        userFriend = object
    }

    // MARK: - Service requests -
    
    func loadData() {
        getProfile()
        
        name.value = userFriend.name
        email.value = userFriend.email
    }
    
    private func getProfile() {
        serviceModel.getProfile(facebookId: userFriend.facebookId) { [weak self] (user) in
            self?.userDetail = user
            self?.delegate?.reloadData?()
        }
    }
    
    private func getShowTrackDetail() {
        guard let show = userDetail?.showsTrackList?.first, let showId = show.showId else {
            return
        }
        
        let dictionary = [TVShow.SerializationKeys.id: showId]
        let tvShow = TVShow(object: dictionary)
        tvShowDetailServiceModel.getDetail(from: tvShow) { [weak self] (object) in
            self?.tvShowDetail = object
        }
    }
    
    // MARK: - View Model -
    
    func sectionTitle(at section: Int) -> String {
        switch arrayYourListSections[section] {
        case .wantToSeeMovies: return Titles.wantToSeeMovies.localized
        case .tvShowsTrack: return Titles.tvShowsTrack.localized
        case .seenMovies: return Titles.seenMovies.localized
        }
    }
    
    // MARK: - View Model instanstiation -
    
    func personalityTestResultViewModel() -> PersonalityTestResultViewModel {
        return PersonalityTestResultViewModel(userPersonality: userDetail?.personality)
    }
    
    func yourListViewModel(at indexPath: IndexPath) -> YourListViewModel? {
        guard let user = userDetail else {
            return nil
        }
        return YourListViewModel(object: arrayYourListSections[indexPath.section], user: user)
    }
}
