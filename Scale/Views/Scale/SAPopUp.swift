//
//  SAPopUp.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/29/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView

class SAPopUp: UIViewController {
    
    @IBOutlet weak var lblDate: UITextField!
    @IBOutlet weak var txtDay: UITextField!
    
    var date = ""
    var day = ""
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDate.text = self.date
        self.txtDay.text = self.day
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnView(_ sender: UIButton)
    {
        let vc: SADayDetails = AppDelegate.storyboard.instanceVC()
        vc.date = self.lblDate.text!
        vc.isView = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnPause(_ sender: UIButton)
    {
        self.Pause()
    }
    
    @IBAction func btnEdit(_ sender: UIButton)
    {
        let vc: SADayDetails = AppDelegate.storyboard.instanceVC()
        vc.date = self.lblDate.text!
        vc.isView = false
        vc.day_id = String(self.id)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnRate(_ sender: UIButton)
    {
        let vc:SARate = AppDelegate.storyboard.instanceVC()
        vc.id = self.id
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let popupViewController = BIZPopupViewController(contentViewController: vc, contentSize: CGSize(width: screenWidth, height: screenHeight))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        self.present(popupViewController!, animated: true, completion: nil)        
    }
    
    
    func Pause()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.editPlanMeals(day_id: self.id, category_id: 0, meal_id: 0, pause: 1)
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
}
