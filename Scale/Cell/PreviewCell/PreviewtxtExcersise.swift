//
//  txtExcersise.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class PreviewtxtExcersise: UITableViewCell  {

    @IBOutlet weak var txtMsg: UITextView!
    var note = ""
    var isEdit = false
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.txtMsg.placeholder = "Excersise Notes"
        self.txtMsg.placeholderColor = "FFFFFF".color

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
