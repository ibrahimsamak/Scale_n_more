//
//  TagCell.swift
//  Events
//
//  Created by ibrahim M. samak on 7/16/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTag: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.layer.cornerRadius = 5
        viewContent.layer.masksToBounds = true
        viewContent.layer.borderWidth = 1
        viewContent.layer.borderColor = UIColor.white.cgColor
    }
}
