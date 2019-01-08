//
//  CustomeView.swift
//  Cheaps
//
//  Created by ibrahim M. samak on 5/20/17.
//  Copyright © 2017 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

class CustomeButton: UIButton
{
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.cornerRadius = 21
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}



class CustomeButton2: UIButton
{
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.cornerRadius = 21
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = "FF8181".color.cgColor
    }
}
