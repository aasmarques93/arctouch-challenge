//
//  CastView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/26/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

class CastView: XibView {
    @IBOutlet weak var imageViewCharacter: UIImageView!
    @IBOutlet weak var labelCharacter: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = HexColor.primary.color
        labelCharacter.textColor = UIColor.white
        labelName.textColor = UIColor.white
    }
}
