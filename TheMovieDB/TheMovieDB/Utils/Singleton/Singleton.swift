//
//  Singleton.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/8/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct Singleton {
    static var shared = Singleton()
    
    var userPersonalityType: PersonalityType? {
        guard let object = UserDefaultsWrapper.fetchUserDefaults(key: Constants.UserDefaults.userPersonality) as? String else {
            return nil
        }
        
        return PersonalityType(object: object.jsonObject ?? object)
    }
    
    var didSkipTestFromLauching = false
    
    var isPersonalityTestAnswered: Bool {
        return userPersonalityType != nil
    }
}
