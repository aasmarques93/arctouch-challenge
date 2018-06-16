//
//  LocalJSONWrapper.swift
//  Figurinhas
//
//  Created by Arthur Augusto Sousa Marques on 3/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import SwiftyJSON

struct JSONWrapper {
    static func json(from resource: RequestUrl) -> URL? {
        return Bundle.main.url(forResource: resource.rawValue, withExtension: "json")
    }
    
    static func json(from resource: RequestUrl, handler: @escaping (JSON?) -> ()) {
        do {
            if let file = Bundle.main.url(forResource: resource.rawValue, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = JSON(data: data)
                handler(json)
            }
        } catch {
            print(error.localizedDescription)
            handler(nil)
        }
    }
}
