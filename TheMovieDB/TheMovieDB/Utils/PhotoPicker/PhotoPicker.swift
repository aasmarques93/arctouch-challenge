//
//  PhotoPicker.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 5/18/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import Photos

protocol PhotoPickerDelegate: class {
    func dismissPhotoPicker(selectedImage: UIImage?, pathUrl: URL?)
}

class PhotoPicker: UIImagePickerController {
    static let shared = PhotoPicker()
    
    weak var photoPickerDelegate: PhotoPickerDelegate?
    
    lazy var imageManager = {
        return PHCachingImageManager()
    }()
    
    private var buttonPicker: UIButton {
        let buttonPicker = UIButton()
        buttonPicker.setTitle(Titles.photos.localized, for: .normal)
        buttonPicker.setTitleColor(UIColor.white, for: .normal)
        buttonPicker.addTarget(self, action: #selector(openLibrary), for: .touchUpInside)
        buttonPicker.sizeToFit()
        buttonPicker.frame = CGRect(x: view.frame.maxX - buttonPicker.frame.width - 8,
                                    y: 0,
                                    width: buttonPicker.frame.width,
                                    height: buttonPicker.frame.height)
        return buttonPicker
    }
    
    func present(in viewController: UIViewController) {
        delegate = self
        allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sourceType = .camera
            cameraCaptureMode = .photo
            mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        } else {
            sourceType = .savedPhotosAlbum
            mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        }

        cameraOverlayView = buttonPicker
        viewController.present(self, animated: true, completion: nil)
    }
    
    @objc func openLibrary() {
        sourceType = .savedPhotosAlbum
        mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
    }
}
 
extension PhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        photoPickerDelegate?.dismissPhotoPicker(selectedImage: info[UIImagePickerControllerOriginalImage] as? UIImage,
                                                pathUrl: info[UIImagePickerControllerImageURL] as? URL)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
