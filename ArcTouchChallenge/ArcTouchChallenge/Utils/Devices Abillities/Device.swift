//
//  Device.swift
//  ArcTouchChallenge
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class Device {
    static let iPhone4 = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height < 568.0
    static let iPhone5 = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 568.0
    static let iPhone = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 667.0
    static let iPhonePlus = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 736.0
    static let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 812.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .pad
    static let iPadPro = UIDevice.current.userInterfaceIdiom == .pad && (UIScreen.main.bounds.size.height == 1366.0 || UIScreen.main.bounds.size.width == 1366.0)
    
    static var width: CGFloat { return UIScreen.main.bounds.size.width }
}
