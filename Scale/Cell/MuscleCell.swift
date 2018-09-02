//
//  MuscleCell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class MuscleCell: UITableViewCell {
    @IBOutlet weak var lblFreq: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblSubmuscle: UILabel!
    @IBOutlet weak var lblmuscle: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
