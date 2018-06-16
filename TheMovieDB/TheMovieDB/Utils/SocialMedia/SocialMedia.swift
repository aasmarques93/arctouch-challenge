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
    case netflix
}

struct SocialMedia {
    enum Links: String {
        case facebook = "fb://profile/"
        case webFacebook = "https://facebook.com/"
        case instagram = "instagram://user?username="
        case webInstagram = "https://instagram.com/"
        case twitter = "twitter://user?screen_name="
        case webTwitter = "https://twitter.com/"
        case netflix = "nflx://www.netflix.com/watch/"
        case webNetflix = "http://movies.netflix.com/Movie/"
        
        static func url(with link: Links, id: String? = nil) -> String {
            return "\(link.rawValue)\(id ?? "")"
        }
    }
    
    static func open(mediaType: SocialMediaType, id: String?) {
        var urls = [String]()
        
        switch mediaType {
        case .facebook:
            urls.append(Links.url(with: .webFacebook, id: id))
        case .instagram:
            urls.append(Links.url(with: .instagram, id: id))
            urls.append(Links.url(with: .webInstagram, id: id))
        case .twitter:
            urls.append(Links.url(with: .twitter, id: id))
            urls.append(Links.url(with: .webTwitter, id: id))
        case .netflix:
            urls.append(Links.url(with: .netflix, id: id))
            urls.append(Links.url(with: .webNetflix, id: id))
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
