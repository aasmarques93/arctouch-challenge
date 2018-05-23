//
//  UserPersonality.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/23/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserPersonality: Model {
    var json: JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let title = "title"
        static let color = "color"
        static let text = "text"
        static let personalityTypeId = "personalityTypeId"
        static let comedyPercentage = "comedyPercentage"
        static let actionPercentage = "actionPercentage"
        static let dramaPercentage = "dramaPercentage"
        static let thrillerPercentage = "thrillerPercentage"
        static let documentaryPercentage = "documentaryPercentage"
    }
    
    // MARK: Properties
    var title: String?
    var color: String?
    var text: String?
    var personalityTypeId: Int?
    var comedyPercentage: Float?
    var actionPercentage: Float?
    var dramaPercentage: Float?
    var thrillerPercentage: Float?
    var documentaryPercentage: Float?
    
    // MARK: SwiftyJSON Initializers
    init(object: Any) {
        if let json = object as? JSON {
            self.init(json: json)
            return
        }
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    init(json: JSON?) {
        self.json = json
        title = json?[SerializationKeys.title].string
        color = json?[SerializationKeys.color].string
        text = json?[SerializationKeys.text].string
        personalityTypeId = json?[SerializationKeys.personalityTypeId].int
        comedyPercentage = json?[SerializationKeys.comedyPercentage].float
        actionPercentage = json?[SerializationKeys.actionPercentage].float
        dramaPercentage = json?[SerializationKeys.dramaPercentage].float
        thrillerPercentage = json?[SerializationKeys.thrillerPercentage].float
        documentaryPercentage = json?[SerializationKeys.documentaryPercentage].float
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = title { dictionary[SerializationKeys.title] = value }
        if let value = color { dictionary[SerializationKeys.color] = value }
        if let value = text { dictionary[SerializationKeys.text] = value }
        if let value = personalityTypeId { dictionary[SerializationKeys.personalityTypeId] = value }
        if let value = comedyPercentage { dictionary[SerializationKeys.comedyPercentage] = value }
        if let value = actionPercentage { dictionary[SerializationKeys.actionPercentage] = value }
        if let value = dramaPercentage { dictionary[SerializationKeys.dramaPercentage] = value }
        if let value = thrillerPercentage { dictionary[SerializationKeys.thrillerPercentage] = value }
        if let value = documentaryPercentage { dictionary[SerializationKeys.documentaryPercentage] = value }
        return dictionary
    }
}
