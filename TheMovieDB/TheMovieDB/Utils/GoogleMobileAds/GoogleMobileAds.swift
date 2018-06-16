//
//  GoogleAdsHelper.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 6/7/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import GoogleMobileAds

// MARK: - Constants -

private let applicationId = "ca-app-pub-5274645490547792~5221900735"
private let insterstitialUnitId = "ca-app-pub-5274645490547792/9404812030"

// TO DO: CHANGE TO PRODUCTION ID
private let rewardVideoUnitId = "ca-app-pub-3940256099942544/1712485313" // PRODUCTION "ca-app-pub-5274645490547792/9727696921"

class GoogleAdsHelper: NSObject {
    static let shared = GoogleAdsHelper()
    
    // MARK: - Properties -
    private var interstitial: GADInterstitial!
    
    // MARK: - Life cycle -
    override init() {
        super.init()
        setupInterstitial()
        setupRewardVideo()
    }
    
    // MARK: - Configuration -
    
    func configure() {
        GADMobileAds.configure(withApplicationID: applicationId)
    }
    
    // MARK: - Interstitial -
    
    private func setupInterstitial() {
        interstitial = GADInterstitial(adUnitID: insterstitialUnitId)
        interstitial.delegate = self
        interstitial.load(GADRequest())
    }
    
    func showInterstitial() {
        guard let viewController = UIApplication.topViewController() else {
            return
        }
        guard interstitial.isReady else {
            print("Ad wasn't ready")
            return
        }
        interstitial.present(fromRootViewController: viewController)
    }
    
    // MARK: - Reward Video -
    
    func setupRewardVideo() {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: rewardVideoUnitId)
    }
    
    func showRewardVideo() {
        guard let viewController = UIApplication.topViewController() else {
            return
        }
        guard GADRewardBasedVideoAd.sharedInstance().isReady else {
            print("Video wasn't ready")
            return
        }
        GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: viewController)
    }
}

extension GoogleAdsHelper: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
    
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        setupInterstitial()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        
    }
}

extension GoogleAdsHelper: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    }
    
    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        setupRewardVideo()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {

    }
    
    private func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        
    }
}
