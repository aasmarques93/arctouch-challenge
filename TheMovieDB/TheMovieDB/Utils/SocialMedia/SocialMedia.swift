//
//  SocialMedia.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/27/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

enum SocialMediaType {
    case facebook
    case instagram
    case twitter
}

struct SocialMedia {
    static let shared = SocialMedia()
 
    enum Links: String {
        case facebook = "fb://profile/"
        case webFacebook = "https://facebook.com/"
        case instagram = "instagram://user?username="
        case webInstagram = "https://instagram.com/"
        case twitter = "twitter://user?screen_name="
        case webTwitter = "https://twitter.com/"
        
        static func url(with link: Links, userId: String? = nil) -> String {
            return "\(link.rawValue)\(userId ?? "")"
        }
    }
    
    func open(mediaType: SocialMediaType, userId: String?) {
        var urls = [String]()
    
        switch mediaType {
            case .facebook:
                urls.append(Links.url(with: .webFacebook, userId: userId))
            case .instagram:
                urls.append(Links.url(with: .instagram, userId: userId))
                urls.append(Links.url(with: .webInstagram, userId: userId))
            case .twitter:
                urls.append(Links.url(with: .twitter, userId: userId))
                urls.append(Links.url(with: .webTwitter, userId: userId))
        }
        
        UIApplication.open(urls: urls)
    }
    
}

extension UIApplication {
    class func open(urls: [String]) {
        let application = UIApplication.shared
        
        for string in urls {
            print("Trying to open: \(string)")
            if let url = URL(string: string), application.canOpenURL(url) {
                application.open(url, options: [:], completionHandler: nil)
                return
            }
        }
    }
}
