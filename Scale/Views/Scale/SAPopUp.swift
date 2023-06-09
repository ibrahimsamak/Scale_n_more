//
//  SAPopUp.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/29/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView
protocol loadDataprotocal {
    func loadDate()


}
class SAPopUp: UIViewController {
    
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var lblDate: UITextField!
    @IBOutlet weak var txtDay: UITextField!
    
    @IBOutlet weak var viewMeals: UIView!
    @IBOutlet weak var viewEditemeal: UIView!
    @IBOutlet weak var viewPuse: UIView!
    @IBOutlet weak var lblpause: UILabel!
    var date = ""
    var day = ""
    var id = 0
    var pause = ""
    var delegate: loadDataprotocal?
    var hourString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblDate.text = self.date
        self.txtDay.text = self.day
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        hourString = formatter.string(from: Date())
        

        if pause == "0"{
            if(Language.currentLanguage().contains("ar")){
                lblpause.text = "ايقاف"
                pause = "1"
            }else{
                lblpause.text = "Pause"
                pause = "1"
            }
          
        }else{
            
            if(Language.currentLanguage().contains("ar")){
                lblpause.text = "الغاء الايقاف"
                pause = "0"
            }else{
                lblpause.text = "UnPause"
                pause = "0"
            }
           

        }
       
        
//        if hourString.compare(lblDate.text!) == .orderedDescending {
//            print("First Date is greater then second date")
//            self.viewMeals.isHidden = true
//            self.viewPuse.isHidden = true
//            self.viewEditemeal.isHidden = true
//            self.viewRate.isHidden = false
//        }else{
//            print("First Date is not greater then second date")
//
//        }

        

        
          //  let date = Date(timeIntervalSinceNow: 172800)
        let date2 = Date(timeIntervalSinceNow: 86400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString2 = dateFormatter.string(from: date2)
//
        if dateString2 == lblDate.text {
            self.viewMeals.isHidden = false
            self.viewPuse.isHidden = true
            self.viewEditemeal.isHidden = true
            self.viewRate.isHidden = true
        }else if hourString == lblDate.text{
            self.viewMeals.isHidden = false
            self.viewPuse.isHidden = true
            self.viewEditemeal.isHidden = true
            self.viewRate.isHidden = true
        }else if hourString.compare(lblDate.text!) == .orderedDescending{
            self.viewMeals.isHidden = true
            self.viewPuse.isHidden = true
            self.viewEditemeal.isHidden = true
            self.viewRate.isHidden = false
        }else{
                        self.viewMeals.isHidden = false
                        self.viewPuse.isHidden = false
                        self.viewEditemeal.isHidden = false
                        self.viewRate.isHidden = true

        }
        
        
//        if dateString2 == lblDate.text || hourString == lblDate.text {
//            self.viewMeals.isHidden = false
//            self.viewPuse.isHidden = true
//            self.viewEditemeal.isHidden = true
//            self.viewRate.isHidden = true
//
//        }else{
//            self.viewMeals.isHidden = false
//            self.viewPuse.isHidden = false
//            self.viewEditemeal.isHidden = false
//            self.viewRate.isHidden = true
//
//        }
//
        

        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblDate.textAlignment = .right
            self.txtDay.textAlignment = .right
        }
        else
        {
            self.lblDate.textAlignment = .left
            self.txtDay.textAlignment = .left
        }
        
        
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
        if pause == "1"{
            self.showCustomAlert(okFlag: false, title: "Pause".localized, message: "Do you want to pause this day?".localized, okTitle: "Yes".localized, cancelTitle: "No".localized)
            {(success) in
                if(success)
                {
                    self.Pause()
                    self.delegate?.loadDate()
                    
                    self.dismiss(animated: true, completion: nil)
                }}
//            self.showOkAlertWithComp(title: "Pause".localized, message: "Do you want to pause this day?".localized, completion: { (success) in
//                if(success)
//                {
//                    self.Pause()
//                    self.delegate?.loadDate()
//
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
          //  lblpause.text = "Pause"
            //pause = "1"
            // هل ترغب في ايقاف هذا اليوم
        }else{
            
            
            self.showCustomAlert(okFlag: false, title: "Un Pause".localized, message: "Do you want to un pause this day?".localized, okTitle: "Yes".localized, cancelTitle: "No".localized)
            {(success) in
                if(success)
                {
                    self.Pause()
                    self.delegate?.loadDate()
                    
                    self.dismiss(animated: true, completion: nil)
                }}
//            self.showOkAlertWithComp(title: "Un Pause".localized, message: "Do you want to un pause this day?".localized, completion: { (success) in
//                if(success)
//                {
//                    self.Pause()
//                    self.delegate?.loadDate()
//
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
//
            
        }

        

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
            MyApi.api.PauseDay(date: self.lblDate.text!, pause: pause,plan_id:id )
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
