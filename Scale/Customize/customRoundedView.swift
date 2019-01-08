//
//  customRoundedView.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/28/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

class customRoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.topLeft, .topRight], radius: 5)
    }
}
