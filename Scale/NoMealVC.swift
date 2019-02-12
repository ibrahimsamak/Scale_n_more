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
   // let Myemail = MyTools.tools.getMyemail()
//    let MyPhone = MyTools.tools.getMymobile()
   // let MyName = MyTools.tools.getMyname()
    var type = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text =  MyTools.tools.getConfigString("how_it_work")

      
    }
    @IBAction func btnHome(_ sender: UIButton)
    {
        self.navigationController?.popToRoot(animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    @IBAction func btnGoToContact(_ sender: UIButton)
    {
        
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            self.showIndicator()
            MyApi.api.PostContact(fullname: MyTools.tools.getMyname(), email: MyTools.tools.getMyemail(), comment: "meal", mobile:MyTools.tools.getMymobile() , type:type) { (response, error) in
                if(response.result.value != nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if(status == true)
                        {
                            self.hideIndicator()
                            self.showOkAlertWithComp(title: "Success".localized, message:  JSON["message"] as? String ?? "", completion: { (Success) in
                                if(Success){
                                    self.navigationController?.pop(animated: true)
                                }
                            })
                        }
                        else
                        {
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                        self.hideIndicator()
                    }
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized.localized, message: "An Error occurred".localized)
                }
            }
            
        }else{
        self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want logout?".localized, okTitle: "Logout".localized, cancelTitle: "Cancel".localized)
        {(success) in
            if(success)
            {
                let vc : LoginNav = AppDelegate.storyboard.instanceVC()
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = vc
                appDelegate?.window??.makeKeyAndVisible()
            }}}
        
       

//        let vc:SAContactUs = AppDelegate.storyboard.instanceVC()
//        vc.type = 1
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}
