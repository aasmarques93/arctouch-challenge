//
//  RAMTabBarUtils.swift
//  GFP
//
//  Created by Arthur Augusto Sousa Marques on 5/3/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

extension RAMAnimatedTabBarItem {
    open override func awakeFromNib() {
        super.awakeFromNib()
        textColor = UIColor.lightGray
        iconColor = textColor
    }
}

extension RAMItemAnimation {
    open override func awakeFromNib() {
        super.awakeFromNib()
        textSelectedColor = HexColor.secondary.color
        iconSelectedColor = textSelectedColor
    }
}
