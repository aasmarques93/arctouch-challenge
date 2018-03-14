//
//  Model.swift
//  Water
//
//  Created by Arthur Augusto Sousa Marques on 01/02/17.
//  Copyright © 2017 Arthur Augusto Sousa Marques. All rights reserved.
//

import SwiftyJSON

class Model: NSObject {
    var json : JSON?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let msg = "msg"
        static let msgErro = "msgErro"
    }
    
    public var msg: String?
    public var msgErro: String?
    
    // MARK: - Constructors -
    
    override init() {
        
    }
    
    convenience init(object : Any) {
        self.init(json: JSON(object))
    }
    
    required init(json: JSON){
        msg = json[SerializationKeys.msg].string
        msgErro = json[SerializationKeys.msgErro].string
        self.json = json
    }
    
    func saveUserDefaults(name: String) {
        if let json = json { UserDefaults.standard.set(json.description, forKey: name) }
    }
    
    func getJSON() -> JSON? {
        return json
    }
}
