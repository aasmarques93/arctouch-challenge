//
//  PopularPeopleCellViewModel.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Bond

class PopularPersonCellViewModel: ViewModel {
    var person: Person?
    
    var photo = Observable<UIImage>(#imageLiteral(resourceName: "default-image"))
    var name = Observable<String?>(nil)
    var isActivityIndicatorHidden = Observable<Bool>(false)
    
    init(_ object: Person) {
        super.init()
        self.person = object
    }
    
    func setupData() {
        name.value = valueDescription(person?.name)
        
        if let data = person?.imageData, let image = UIImage(data: data) {
            isActivityIndicatorHidden.value = true
            photo.value = image
            return
        }
        
        isActivityIndicatorHidden.value = false
        ServiceModel().loadImage(path: person?.profilePath ?? "", handlerData: { (data) in
            self.isActivityIndicatorHidden.value = true
            if let data = data as? Data, let image = UIImage(data: data) {
                self.person?.imageData = data
                self.photo.value = image
            }
        })
    }
}
