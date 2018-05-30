//
//  Extensions.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

//Screen Related Values
var SCREEN_WIDTH: CGFloat {
    return UIScreen.main.bounds.width
    
}
var SCREEN_HEIGHT: CGFloat {
    return AppDelegate.shared.window!.frame.height
}

extension Array {
    mutating func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
    
    var shuffled: Array {
        var array = self
        array.shuffle()
        return array
    }
    
    func added(_ element: Element) -> Array {
        var array = self
        array.append(element)
        return array
    }
    
    func contains(_ object: AnyObject) -> Bool {
        if self.isEmpty {
            return false
        }
        
        let array = NSArray(array: self)
        
        return array.contains(object)
    }
    
    func index(of object: AnyObject) -> Int? {
        if self.contains(object) {
            let array = NSArray(array: self)
            
            return array.index(of: object)
        }
        
        return nil
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UITableView {
    func dequeueReusableCell<T:UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing:T.self), for: indexPath) as? T else {
            fatalError("Cant dequeue cell with identifier: \(String(describing:T.self))")
        }
        
        return cell
    }
}

extension UICollectionView {
    func dequeueReusableCell<T:UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing:T.self), for: indexPath) as? T else {
            fatalError("Cant dequeue cell with identifier: \(String(describing:T.self))")
        }
        return cell
    }
}

protocol ReusableView: class { }

extension ReusableView where Self:UIView {
    static var reuseIdentifier: String {
        return String(describing:self)
    }
}

extension UIViewController {
    var reusableIdentifier: String {
        return String(describing:self)
    }
    
    func takeScreenshot(shouldSave: Bool = true) -> UIImage? {
        guard let layer = AppDelegate.shared.window?.layer else {
            return nil
        }
        
        var screenshotImage: UIImage?
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return screenshotImage
    }
    
    func presentShareActivityController(image: UIImage?,
                                        excludedActivityTypes: [UIActivityType] = []) {
        
        guard let image = image else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension UITableViewCell {
    func setSelectedView(backgroundColor: UIColor) {
        let selectedView = UIView()
        selectedView.backgroundColor = backgroundColor
        selectedBackgroundView = selectedView
    }
    
    func alternateBackground(at indexPath: IndexPath,
                             mainColor: UIColor = HexColor.primary.color,
                             secondaryColor: UIColor = HexColor.secondary.color) {
        
        backgroundColor = indexPath.row % 2 == 0 ? mainColor: secondaryColor
    }
}

protocol ReusableIdentifier: class { }

extension ReusableIdentifier where Self:UIViewController {
    static var identifier: String {
        return String(describing:self)
    }
}

extension UIViewController: ReusableIdentifier { }

extension UIView: ReusableIdentifier { }

extension UITabBarController {
    func setTabBarVisible(visible: Bool, animated: Bool) {
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height: height)
        UIView.animate(withDuration: animated ? 0.3: 0.0) {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
}

extension UIAlertController {
    func presentAnywhere() {
        UIAlertController.getTopViewController().present(self, animated: true, completion: nil)
    }
    
    static func getTopViewController() -> UIViewController {
        var viewController = UIViewController()
        if let vc =  UIApplication.shared.delegate?.window??.rootViewController {
            viewController = vc
            var presented = vc
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }
        return viewController
    }
}

extension Collection where Index == Int {
    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }
}

extension Array {
    func shiftRight(_ amount: Int = 1) -> [Element] {
        var value = amount
        if value < 0 { value += count }
        return Array(self[value ..< count] + self[0 ..< value])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}

extension UIImage {
    func getDataWithProportion (_ heightDesired: Double) -> Data?{
        let proportion: Double = Double(self.size.width) / Double(self.size.height)
        let selectedImage = self.imageResize(sizeChange: CGSize(width: heightDesired*proportion, height: heightDesired))
        if let imageData:Data = UIImagePNGRepresentation(selectedImage) {
            return imageData
        }
        return nil
    }
}

extension UITableViewController {
    var viewHeaderTitleHeight: CGFloat {
        return 32
    }
    
    var labelHeader: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: viewHeaderTitleHeight))
        label.backgroundColor = HexColor.primary.color
        label.textColor = HexColor.text.color
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }
}

extension Int {
    static func random(lower: Int, upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}
