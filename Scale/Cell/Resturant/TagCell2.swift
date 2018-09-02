//
//  TagCell2.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/17/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class TagCell2: UICollectionViewCell {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        view.roundCorners([.topLeft, .topRight], radius: 5)
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            
        }
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor

        ColorView.clipsToBounds = true
        ColorView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            ColorView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
           
        }
    }

}
