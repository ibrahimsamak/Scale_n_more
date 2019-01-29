//
//  SASettings.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SafariServices

class SASettings: UIViewController {

    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutlable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if ((UserDefaults.standard.object(forKey: "CurrentUser")) == nil)
        {
//            logoutView.isHidden = true
            self.logoutlable.text = "login".localized
        }
        else{
            logoutView.isHidden = false
        }
        
        if(Language.currentLanguage().contains("ar")){
            self.icon1.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.icon2.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.icon3.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.icon4.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.icon5.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
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
        if(sender.tag == 0)
        {
            //ar
            Language.setAppLanguage(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.rootnavigationController()
            print(Language.currentLanguage())
        }
        else{
            //en
            Language.setAppLanguage(lang: "en-US")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.rootnavigationController()
            print(Language.currentLanguage())
        }
        self.SetupConfig()
    }
    
    func SetupConfig()
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyApi.api.GetConfig(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            let items = JSON["items"] as! NSDictionary
                            let Setting = items.value(forKey: "Setting") as! NSDictionary
                            let Country = items.value(forKey: "Country") as! NSArray
                            UserDefaults.standard.setValue(Country, forKey: "Country")
                            
                            for (key,value) in Setting {
                                print("\(key) = \(value)")
                                let val = value as? String ?? ""
                                let ns = UserDefaults.standard
                                ns.setValue(val, forKey: key as! String)
                                ns.synchronize()
                            }
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                        
                    }
                    
                }
                else
                {
                    
                }
            }
        }
        else
        {
            
        }
    }
    func rootnavigationController()
    {
        guard let window = UIApplication.shared.keyWindow else { return }
        let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
        window.rootViewController = vc
    }
    
    
    @IBAction func btnLogout(_ sender: UIButton)
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) == nil)
        {
            let vc : LoginNav = AppDelegate.storyboard.instanceVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = vc
            appDelegate?.window??.makeKeyAndVisible()

            return
        }
        self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want logout?".localized, okTitle: "Logout".localized, cancelTitle: "Cancel".localized)
        {(success) in
            if(success)
            {
                self.showIndicator()

                MyApi.api.Logout(){(response, err) in
                    if((err) == nil)
                        
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {

                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                self.hideIndicator()

                                let ns = UserDefaults.standard
                                ns.removeObject(forKey: "CurrentUser")
                                let vc : LoginNav = AppDelegate.storyboard.instanceVC()
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = vc
                                appDelegate?.window??.makeKeyAndVisible()

                                
                                
                            }
                            else
                            {
                                self.hideIndicator()
                                self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)

                            }
                        }
                    }
                    else{
                        
                    }
                }
            }
        }
    }
    @IBAction func btnLine(_ sender: UIButton)
    {
        let urlString = "http://www.linekw.com"
        let url = URL(string: urlString)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true, completion: nil)
    }
    
}
