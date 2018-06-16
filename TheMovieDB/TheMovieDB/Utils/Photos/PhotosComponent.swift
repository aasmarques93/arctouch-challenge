
//
//  PhotosComponent.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/5/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import AXPhotoViewer

struct Photo {
    var title: String?
    var description: String?
    var credit: String?
    var image: UIImage?
    var data: Data?
    var url: URL?

    init(title: String? = nil,
         description: String? = nil,
         credit: String? = nil,
         image: UIImage? = nil,
         data: Data? = nil,
         url: URL? = nil) {

        self.title = title
        self.description = description
        self.credit = credit
        self.image = image
        self.data = data
        self.url = url
    }
}

struct PhotosComponent {
    static func present(from viewController: UIViewController? = nil, photos: [Photo]?) {
        guard let photos = photos else {
            return
        }

        var arrayPhotos = [AXPhoto]()

        photos.forEach { (photo) in
            arrayPhotos.append(AXPhoto(attributedTitle: NSAttributedString(string: photo.title ?? ""),
                                       attributedDescription: NSAttributedString(string: photo.description ?? ""),
                                       attributedCredit: NSAttributedString(string: photo.credit ?? ""),
                                       imageData: photo.data,
                                       image: photo.image,
                                       url: photo.url))
        }

        let dataSource = AXPhotosDataSource(photos: arrayPhotos)
        let photosViewController = AXPhotosViewController(dataSource: dataSource)

        guard let viewController = viewController else {
            UIApplication.topViewController()?.present(photosViewController, animated: true)
            return
        }

        viewController.present(photosViewController, animated: true)
    }
}
