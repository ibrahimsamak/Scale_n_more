//
//  SAHome.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAHome: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        MyApi.api.GetProfile(){(response, err) in
            if((err) == nil)
                
            {
                if let JSON = response.result.value as? NSDictionary
                {
                    let  status = JSON["status"] as? Bool
                    if (status == true)
                    {
                        print("success")
                        let UserArray = JSON["items"] as? NSDictionary
                        let ns = UserDefaults.standard
                        
                        let CurrentUser:NSDictionary =
                            [
                                "id":UserArray?.value(forKey: "id") as! Int,
                                "access_token":UserArray?.value(forKey: "access_token") as! String,
                                "name":UserArray?.value(forKey: "name") as! String,
                                "check_meal": UserArray?.value(forKey: "check_meal") as! Int
                        ]
                        
                        ns.setValue(CurrentUser, forKey: "CurrentUser")
                        ns.synchronize()
                        
                        
                    }
                    else
                    {
                    }
                }
            }
            else{
                
            }
        }

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnWorkout(_ sender: UIButton)
    {
        let vc:SAWorkout = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSettings(_ sender: UIButton)
    {
        let vc:SASettings = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnScale(_ sender: UIButton)
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let checkMealPackage = MyTools.tools.checkMealPackage()
            if(checkMealPackage == 0){
                let vc:NoMealVC = AppDelegate.storyboard.instanceVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc:SAScaleResturant = AppDelegate.storyboard.instanceVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
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
