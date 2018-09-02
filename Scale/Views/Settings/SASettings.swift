//
//  SASettings.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SASettings: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnAction(_ sender: UIButton)
    {
        switch sender.tag {
        case 0:
            let vc:SAAboutUs = AppDelegate.storyboard.instanceVC()
            vc.type = "terms"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc:SAAboutUs = AppDelegate.storyboard.instanceVC()
            vc.type = "privacy"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc:SAAboutUs = AppDelegate.storyboard.instanceVC()
            vc.type = "About"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc:SAContactUs = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
    @IBAction func btnLanguage(_ sender: UIButton)
    {
        if(sender.tag == 0){
            //ar
        }
        else{
            //en
        }
    }
    
    @IBAction func btnLogout(_ sender: UIButton)
    {
        self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want logout?".localized, okTitle: "Logout".localized, cancelTitle: "Cancel".localized)
        {(success) in
            if(success)
            {
                let ns = UserDefaults.standard
                ns.removeObject(forKey: "CurrentUser")
                let vc : SARootBegin = AppDelegate.storyboard.instanceVC()
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = vc
                appDelegate?.window??.makeKeyAndVisible()
            }
        }
    }
    
}
