//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var window: UIWindow?
    var orientation: UIInterfaceOrientationMask = .all

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
    func lockOrientation(_ orientation: UIInterfaceOrientationMask = .portrait,
                         andRotateTo rotateOrientation: UIInterfaceOrientation = .portrait) {
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        self.orientation = orientation
    }
    
    func unlockOrientation() {
        orientation = .all
    }
}

