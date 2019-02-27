//
//  MealsCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/17/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class MealsCell: UITableViewCell {
    @IBOutlet weak var btnZoom: UIButton!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img_circle: UIButton!
    @IBOutlet weak var iconDon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
      
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblTitle.textAlignment = .right
            self.lblDesc.textAlignment = .right

        }
        else
        {
            self.lblTitle.textAlignment = .left
            self.lblDesc.textAlignment = .left

        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
