//
//  SAHumanBodyDetails.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAHumanBodyDetails9: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    var type = ""
    var isFromLibrary = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    @IBAction func btnGoTovideo(_ sender: UIButton)
    {
        let vc:SATrainingVC = AppDelegate.storyboard.instanceVC()
        vc.SubmuscleId = sender.tag
         vc.isFromLibrary = self.isFromLibrary
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
