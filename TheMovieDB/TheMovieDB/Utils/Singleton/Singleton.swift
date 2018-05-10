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
    
    let typingTimeInterval = 0.01
    var arrayPersonalityTypes = [PersonalityType]()
    
    var userPersonalityType: PersonalityType? {
        guard let object = UserDefaultsWrapper.fetchUserDefaults(key: .userPersonality) else {
            return nil
        }
        
        return PersonalityType(object: object)
    }
    
    var userAnsweredQuestions: [Answer] {
        guard let array = UserDefaultsWrapper.fetchUserDefaults(key: .answeredQuestions) as? [[String:Any]] else {
            return [Answer]()
        }
        
        var arrayAnswers = [Answer]()
        
        array.forEach { (object) in
            arrayAnswers.append(Answer(object: object))
        }
        
        return arrayAnswers
    }
    
    func dictionaryAnswersCounts(at array: [Answer] = Singleton.shared.userAnsweredQuestions) -> [Int: Int] {
        var counts = [Int: Int]()
        
        array.forEach { (answer) in
            if let id = answer.personalityTypeId  {
                counts[id, default: 0] += 1
            }
        }
        
        return counts
    }
    
    var didSkipTestFromLauching = false
    var didSkipTest: Bool? {
        guard let value = UserDefaultsWrapper.fetchUserDefaults(key: .didSkipTest) as? Bool else {
            return nil
        }
        return value
    }
    
    var isPersonalityTestAnswered: Bool {
        return userPersonalityType != nil
    }
    
    var arrayGenres = [Genres]()
}
