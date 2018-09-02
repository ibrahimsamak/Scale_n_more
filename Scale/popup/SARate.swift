//
//  SARate.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/29/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SARate: UIViewController {

    @IBOutlet weak var rate: UIView!
    @IBOutlet weak var rateView: FloatRatingView!
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnSend(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.addRate(day_id: self.id, rate: Int(rateView.rating))
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Int
                        if (status == 1)
                        {
                            self.hideIndicator()
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as? String ?? "", completion: { (success) in
                                if(success)
                                {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")
                        }
                    }
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }

    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
