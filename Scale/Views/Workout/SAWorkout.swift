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
    @IBAction func btnHome(_ sender: UIButton)
    {
        self.navigationController?.popToRoot(animated: true)
    }

    
    @IBAction func btnWorkoutPlan(_ sender: UIButton)
    {
     
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let vc: SAWorkoutPlan = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "please you have to sign in".localized, okTitle: "login".localized, cancelTitle: "Cancel".localized)
            {(success) in
                if(success)
                {
                    let vc : LoginNav = AppDelegate.storyboard.instanceVC()
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = vc
                    appDelegate?.window??.makeKeyAndVisible()
                }
            }
        }
        
    }
}
