//
//  XibView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class XibView: UIView {
    class func instanceFromNib<T: UIView>(_: T.Type) -> T {
        return UINib(nibName: String(describing: T.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }
}
