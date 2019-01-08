//
//  DayCollection.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class PreviewDayCollection: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var Allview: UIView!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        Allview.layer.cornerRadius = 22.5
        Allview.layer.masksToBounds = true
        Allview.layer.borderWidth = 1
        Allview.layer.borderColor = "9AC25B".color.cgColor
        
        
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
