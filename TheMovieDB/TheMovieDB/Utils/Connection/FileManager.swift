//
//  FileManager.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation

class FileManager {
    static func load(name: String) -> NSMutableDictionary? {
        if let bundle = Bundle.main.path(forResource: name, ofType: "plist") {
            let file = NSMutableDictionary(contentsOfFile: bundle)
            return file
        }
        return nil
    }
}
