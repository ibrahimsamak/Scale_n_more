//
//  SAWorkout.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAWorkout: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    @IBAction func btnWorkLibrary(_ sender: UIButton)
    {
        //first time
        let vc: SAHumanBody = AppDelegate.storyboard.instanceVC()
        vc.isFromLibrary = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
