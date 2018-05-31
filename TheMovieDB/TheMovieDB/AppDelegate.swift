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
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var window: UIWindow?
    var orientation: UIInterfaceOrientationMask = .all

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        StoreReviewHelper.incrementAppOpenedCount()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Fabric.with([Crashlytics.self])
        Reachability.startListening { (status) in
            if !status {
                let alertController = UIAlertController(style: .alert)
                alertController.show(message: Messages.withoutNetworkConnection.localized)
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            let annotation = options[UIApplicationOpenURLOptionsKey.annotation] as? String else {
            return false
        }
        return FBSDKApplicationDelegate.sharedInstance().application(app,
                                                                     open: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
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

