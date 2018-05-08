//
//  Personality.swift
//
//  Created by Arthur Augusto Sousa Marques on 5/7/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

struct Personality: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let personalityType = "personalityType"
        static let questions = "questions"
    }
    
    // MARK: Properties
    var personalityTypes: [PersonalityType]?
    var questions: [Questions]?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    init(object: Any) {
        if let json = object as? JSON {
            self.init(json: json)
            return
        }
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    init(json: JSON?) {
        self.json = json
        if let items = json?[SerializationKeys.personalityType].array { personalityTypes = items.map { PersonalityType(json: $0) } }
        if let items = json?[SerializationKeys.questions].array { questions = items.map { Questions(json: $0) } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = personalityTypes { dictionary[SerializationKeys.personalityType] = value.map { $0.dictionaryRepresentation() } }
        if let value = questions { dictionary[SerializationKeys.questions] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
    
}
