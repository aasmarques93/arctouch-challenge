//
//  Constants.swift
//  Challenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

struct Constants {
    static let shared = Constants()
    
    let defaultDateFormat = "dd/MM/yyyy"
    let dateFormatIsoTime = "yyyy-MM-dd'T'hh:ss:mm"
}

enum Titles: String {
    /* COMMON TITLES */
    case home = "Home"
    case error = "Error"
    case delete = "Delete"
    case no = "No"
    case yes = "Yes"
    case logout = "Exit"
    case attention = "Attention"
    case success = "Success"
    
    /* Button Common Titles */
    case done = "OK"
    case add = "Add"
    case clear = "Clear"
    case cancel = "Cancel"
    case select = "Select"
}
