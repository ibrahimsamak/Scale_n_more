//
//  SAScaleResturant.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAScaleResturant: UIViewController {
    
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var txtName: UITextField!
    var TItems :NSArray = []
    var dict : NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblDate.textAlignment = .right
            self.lblCount.textAlignment = .right
            self.lblId.textAlignment = .right
            self.txtName.textAlignment = .right
            self.txt1.textAlignment = .right
            self.txt2.textAlignment = .right
            self.txt3.textAlignment = .right
            self.icon1.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.icon2.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        }
        else
        {
            self.lblDate.textAlignment = .left
            self.lblCount.textAlignment = .left
            self.lblId.textAlignment = .left
            self.txtName.textAlignment = .left
            
            self.txt1.textAlignment = .left
            
            self.txt2.textAlignment = .left
            
            self.txt3.textAlignment = .left 
        }
        
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
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
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
