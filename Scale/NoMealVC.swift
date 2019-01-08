//
//  NoMealVC.swift
//  Scale
//
//  Created by ramez adnan on 06/01/2019.
//  Copyright © 2019 ibrahim M. samak. All rights reserved.
//

import UIKit

class NoMealVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    @IBAction func btnGoToContact(_ sender: UIButton)
    {
    
        let vc:SAContactUs = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
