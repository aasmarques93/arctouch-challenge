//
//  ChartGenericCell.swift
//  Vote Presidente
//
//  Created by Arthur Augusto Sousa Marques on 3/15/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

enum ChartContainerHeight: CGFloat {
    case custom = 0
    case small = 220.0
    case standard = 300.0
}

class ChartGenericCell: UITableViewCell {

    //MARK: - Constants -

    let levelPadding: CGFloat = 15.0
    
    static let itemCellHeight: CGFloat = 44.0
    static let disclosureIndicatorWidth: CGFloat = 33.0

    static let xibNameChart = "ChartGenericChartCell"

    static let cellIdChart = "ChartCell"

    //MARK: - Outlets -

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    func setupChartCell() {
        //Adjust right spacing when there is disclosure indicator on chart cells
        if accessoryType == .disclosureIndicator {
            rightConstraint.constant = (accessoryType == .disclosureIndicator) ? -ChartGenericCell.disclosureIndicatorWidth : 0
        }
    }
}
