//
//  SAForgetPassowrd.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAForgetPassowrd: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnSend(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email".localized)
            }
            if !MyTools.tools.validateEmail(candidate: txtEmail.text!)
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter a valid email".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.PostForgetPassword(email: txtEmail.text!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                self.showOkAlert(title: "Success".localized, message: JSON["message"] as? String ?? "")
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
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
}
