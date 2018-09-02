//
//  SADiscount.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
protocol CodeProtocol {
    func SendCode(Code:String)
}
class SADiscount: UIViewController {
   
    @IBOutlet weak var txtCode: UITextField!
    
    var packageID = ""
    var delegate : CodeProtocol!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnActivate(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if((txtCode.text?.count) == 0)
            {
                self.showOkAlert(title: "Error".localized, message: "Please Enter the discount code".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.checkCoupon(coupon_code: txtCode.text!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                self.hideIndicator()
                                self.dismiss(animated: true, completion: {
                                    self.delegate.SendCode(Code: self.txtCode.text!)
                                })
                            }
                            else
                            {
                                self.hideIndicator()
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
