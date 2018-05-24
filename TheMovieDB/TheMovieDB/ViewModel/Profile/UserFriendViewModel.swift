//
//  UserFriendViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/22/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class UserFriendViewModel: ViewModel {
    // MARK: - Delegate -
    weak var delegate: ViewModelDelegate?
    
    // MARK: - Service Model -
    let serviceModel = UserFriendsServiceModel()
    let tvShowDetailServiceModel = TVShowDetailServiceModel()
    
    // MARK: - Observables -
    var isMessageErrorHidden = Observable<Bool>(false)
    
    var backgroundColor = Observable<UIColor>(UIColor.clear)
    var picture = Observable<UIImage>(#imageLiteral(resourceName: "empty-user"))
    var name = Observable<String?>(nil)
    var personality = Observable<String?>(nil)
    var movieShow = Observable<String?>(nil)
    
    var userFriend: User
    var userDetail: User? {
        didSet {
            getShowTrackDetail()
            personality.value = userDetail?.personality?.title
            guard let color = userDetail?.personality?.color else {
                return
            }
            backgroundColor.value = UIColor(hexString: color)
        }
    }
    var tvShowDetail: TVShowDetail? {
        didSet {
            movieShow.value = tvShowDetail?.name
        }
    }
    
    init(object: User) {
        userFriend = object
    }

    func loadData() {
        loadImageData()
        getProfile()
        
        name.value = userFriend.name
    }
    
    private func loadImageData() {
        serviceModel.loadImage(path: userFriend.picture?.data?.url) { [weak self] (data) in
            guard let data = data as? Data, let image = UIImage(data: data) else {
                return
            }
            
            self?.picture.value = image
        }
    }
    
    private func getProfile() {
        serviceModel.getProfile(facebookId: userFriend.facebookId) { [weak self] (object) in
            guard let user = object as? User else {
                return
            }
            self?.userDetail = user
        }
    }
    
    private func getShowTrackDetail() {
        guard let show = userDetail?.showsTrackList?.first, let showId = show.showId else {
            return
        }
        
        let dictionary = ["id": showId]
        let tvShow = TVShow(object: dictionary)
        tvShowDetailServiceModel.getDetail(from: tvShow) { [weak self] (object) in
            self?.tvShowDetail = object as? TVShowDetail
        }
    }
}