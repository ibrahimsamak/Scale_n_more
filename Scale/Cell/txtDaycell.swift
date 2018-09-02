//
//  txtDaycell.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/7/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class txtDaycell: UITableViewCell , UITextFieldDelegate {

    @IBOutlet weak var txtDay: UITextField!
    var dayname = ""
    var isEdit = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config()
    {
        self.txtDay.delegate = self
        if(self.isEdit)
        {
          self.txtDay.text = dayname
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        UserDefaults.standard.set(textField.text, forKey: "DayName")
    }
    

}
