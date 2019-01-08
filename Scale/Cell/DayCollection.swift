//
//  DayCollection.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class DayCollection: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 22.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = "9AC25B".color.cgColor
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lbl.textAlignment = .right
            self.icon.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else
        {
            self.lbl.textAlignment = .left
        }
    }
}
