//
//  PackageCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/15/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class PackageCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lblPackage: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.view.layer.borderColor = "587D30".color.cgColor
        self.view.layer.borderWidth = 1
    }
}
