//
//  ExcersiseCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class ExcersiseCell: UICollectionViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        view.layer.borderWidth = 1
        view.layer.borderColor = "9AC25B".color.cgColor
        
    }
}
