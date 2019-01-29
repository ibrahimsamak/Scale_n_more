//
//  NoMealVC.swift
//  Scale
//
//  Created by ramez adnan on 06/01/2019.
//  Copyright © 2019 ibrahim M. samak. All rights reserved.
//

import UIKit

class NoMealVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text =  MyTools.tools.getConfigString("how_it_work")

      
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    @IBAction func btnGoToContact(_ sender: UIButton)
    {
    
        let vc:SAContactUs = AppDelegate.storyboard.instanceVC()
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
