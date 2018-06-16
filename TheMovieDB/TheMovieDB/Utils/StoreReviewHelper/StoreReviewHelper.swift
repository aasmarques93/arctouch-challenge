//
//  StoreReviewHelper.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import StoreKit

struct StoreReviewHelper {
    // Called from appdelegate didfinishLaunchingWithOptions:
    static func incrementAppOpenedCount() {
        guard var appOpenCount = LocalStorageHelper.fetch(key: .appOpenedCount) as? Int else {
            LocalStorageHelper.save(object: 1, key: .appOpenedCount)
            return
        }
        appOpenCount += 1
        LocalStorageHelper.save(object: appOpenCount, key: .appOpenedCount)
    }
    
    static func checkAndAskForReview() {
        guard let appOpenCount = LocalStorageHelper.fetch(key: .appOpenedCount) as? Int else {
            LocalStorageHelper.save(object: 1, key: .appOpenedCount)
            return
        }
        
        switch appOpenCount {
        case 10, 50:
            requestReview()
        case _ where appOpenCount % 100 == 0 :
            requestReview()
        default:
            print("App run count is : \(appOpenCount)")
            break
        }
    }
    
    private static func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
}
