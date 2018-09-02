//
//  SAScaleResturant.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAScaleResturant: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var txtName: UITextField!
    var TItems :NSArray = []
    var dict : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadDate()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.getInformationMeal(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            self.hideIndicator()
                            self.dict = JSON["items"] as! NSDictionary
                            self.txtName.text = MyTools.tools.getMyname()
                            self.lblId.text = MyTools.tools.getMyId()
                            self.lblDate.text = self.dict.value(forKey: "date") as! String
                            self.lblCount.text = String(self.dict.value(forKey: "count") as! Int)

                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as? String ?? "")                            
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
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
            self.showOkAlert(title: "Error", message: "No Internet Connection")
        }
    }
    
    @IBAction func btnGoToCalender(_ sender: UIButton)
    {
        let vc: SAMealCalender = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRenew(_ sender: UIButton)
    {
        // renew action
        let vc: SAResturantPackages = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
}
