//
//  PlanCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblPlanName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblDay.textAlignment = .right
            self.lblPlanName.textAlignment = .right
        }
        else
        {
            self.lblDay.textAlignment = .left
            self.lblPlanName.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        clearActionsheet()
    }
}
