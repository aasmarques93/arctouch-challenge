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
    
    // MARK: - Observables -
    var isMessageErrorHidden = Observable<Bool>(false)
    
    var backgroundColor = Observable<UIColor>(UIColor.clear)
    var picture = Observable<UIImage>(#imageLiteral(resourceName: "empty-user"))
    var name = Observable<String?>(nil)
    var personality = Observable<String?>(nil)
    var movieShow = Observable<String?>(nil)
    
    var userFriend: User
    var userDetail: User?
    
    init(object: User) {
        userFriend = object
    }

    func loadData() {
        loadImageData()
        getProfile()
        
        name.value = userFriend.name
        
        personality.value = nil
        movieShow.value = nil
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
        serviceModel.getProfile(facebookId: userFriend.facebookId) { (object) in
            
        }
    }
}
