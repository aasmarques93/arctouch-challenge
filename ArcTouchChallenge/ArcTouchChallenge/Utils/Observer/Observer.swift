//
//  Observer.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

enum Observer: String {
    case notification
    
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
