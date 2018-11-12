//
//  SACustomButton.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

class SACustomButton: UIButton
{
    override func awakeFromNib()
    {
        if Language.currentLanguage().contains("ar")
        {
            self.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else{
            //self.imageView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
