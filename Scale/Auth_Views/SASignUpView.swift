//
//  SASignUpView.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView

class SASignUpView: UIViewController, CategoryProtocol,SCPopDatePickerDelegate
{
    func scPopDatePickerDidSelectDate(_ date: Date)
    {
        print(MyTools.tools.convertDateFormater3(date: date))
        let inputDateAsString = MyTools.tools.convertDateFormater3(date: date)
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: inputDateAsString)
        {
            formatter.locale = NSLocale(localeIdentifier: "en-US") as Locale!
            formatter.dateFormat = "yyyy-MM-dd"
            let outputDate = formatter.string(from: date)
            
            print(outputDate)
            self.txtDob.text = outputDate
        }
    }
    
    
    func sendFilter(countryId: String, CountryName: String)
    {
        self.countryId = Int(countryId)!
        self.txtCountry.text = CountryName
    }
    
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtPhone: MaxLengthTextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var boy: UIView!
    @IBOutlet weak var women: UIView!
    
    let datePicker = SCPopDatePicker()
    let date = Date()
    var gender = 0
    var countryId = 0
    
    @objc func myTargetFunction(textField: UITextField)
    {
        textField.text = ""
        self.datePicker.tapToDismiss = true
        self.datePicker.datePickerType = SCDatePickerType.date
        self.datePicker.showBlur = true
        self.datePicker.datePickerStartDate = self.date
        self.datePicker.btnFontColour = UIColor.white
        self.datePicker.btnColour = "8FB952".color
        self.datePicker.showCornerRadius = false
        self.datePicker.delegate = self
        self.datePicker.show(attachToView: self.view)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.boy.layer.cornerRadius = 3
        self.boy.layer.masksToBounds = true
        self.boy.layer.borderWidth = 3
        self.boy.layer.borderColor = "8FB952".color.cgColor
        
        self.women.layer.cornerRadius = 3
        self.women.layer.masksToBounds = true
        self.women.layer.borderWidth = 1
        self.women.layer.borderColor = "E2E2E2".color.cgColor
        
        txtDob.addTarget(self, action:  #selector(SASignUpView.myTargetFunction(textField:)), for: UIControlEvents.touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtPassword.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtDob.textAlignment  = .right
            self.txtName.textAlignment = .right
            self.txtPhone.textAlignment = .right
            self.txtCountry.textAlignment = .right
        }
        else{
            self.txtPassword.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtDob.textAlignment  = .left
            self.txtName.textAlignment = .left
            self.txtPhone.textAlignment = .left
            self.txtCountry.textAlignment = .left
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnGender(_ sender: UIButton)
    {
        if(sender.tag == 0)
        {
            //male
            
            self.boy.layer.cornerRadius = 3
            self.boy.layer.masksToBounds = true
            self.boy.layer.borderWidth = 3
            self.boy.layer.borderColor = "8FB952".color.cgColor
            
            self.women.layer.cornerRadius = 3
            self.women.layer.masksToBounds = true
            self.women.layer.borderWidth = 1
            self.women.layer.borderColor = "E2E2E2".color.cgColor
            self.gender = 1
        }
        else{
            //female
            
            self.boy.layer.cornerRadius = 3
            self.boy.layer.masksToBounds = true
            self.boy.layer.borderWidth = 1
            self.boy.layer.borderColor = "E2E2E2".color.cgColor
            
            self.women.layer.cornerRadius = 3
            self.women.layer.masksToBounds = true
            self.women.layer.borderWidth = 3
            self.women.layer.borderColor = "8FB952".color.cgColor
            self.gender = 2
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    @IBAction func btnCountry(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let smallViewController = storyboard.instantiateViewController(withIdentifier: "SACountry") as! SACountry
        
        smallViewController.delegate = self
        smallViewController.arrayIndex = 0
        
        let popupViewController = BIZPopupViewController(contentViewController: smallViewController, contentSize: CGSize(width: CGFloat(250), height: CGFloat(250)))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        
        self.present(popupViewController!, animated: true, completion: nil)
    }
    
    @IBAction func btnCreate(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            guard txtPhone.text!.count >= 8 else {
                                self.showOkAlert(title: "Error".localized, message: "Please enter your phone number".localized)
                                return
                            }
            if(txtName.text?.count == 0  || txtEmail.text?.count == 0 || txtPassword.text?.count == 0 )
            {
                self.showOkAlert(title: "Error".localized, message: "All fields are required".localized)
            }
            else if txtName.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your name".localized)
            }
//            else if (txtPhone.text?.count)!  == 0 {
//                self.showOkAlert(title: "Error".localized, message: "Please enter your phone number".localized)
//            }
//
//            else if (txtPhone.text?.count)!  >= 8{
//                self.showOkAlert(title: "Error".localized, message: "Please enter your phone number".localized)
//            }
//

                
            else if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email address".localized)
            }
            else if !MyTools.tools.validateEmail(candidate: txtEmail.text!){
                self.showOkAlert(title: "Error".localized, message: "Please enter valid email address".localized)
            }
            else if txtPassword.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your password".localized)
            }
            else if txtDob.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your Date of Birth".localized)
            }
            else if self.countryId == 0{
                self.showOkAlert(title: "Error".localized, message: "Please select your country".localized)
            }
            else{
                //                var deviceToken = MyTools.tools.getDeviceToken()
                //                if deviceToken == nil
                //                {
                //                    deviceToken = InstanceID.instanceID().token()!
                //                }
                //                let image = UIImageJPEGRepresentation(self.img.image!, 0.8) as? Data
                self.showIndicator()
                MyApi.api.PostNewUser(email: txtEmail.text!, name: txtName.text!, mobile: txtPhone.text!, password: txtPassword.text!, confirm_password: txtPassword.text!, gender: self.gender, country_id: self.countryId, date_of_birth: txtDob.text!) { (response, error) in
                    if(response.result.value != nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as? Bool
                            if(status == true)
                            {
                                self.hideIndicator()
                                let UserArray = JSON["items"] as? NSDictionary
                                
                                let ns = UserDefaults.standard
                                let CurrentUser:NSDictionary =
                                    [
    "id":UserArray?.value(forKey: "id") as! Int,
    "access_token":UserArray?.value(forKey: "access_token") as! String,
    "name":UserArray?.value(forKey: "name") as! String,
    "check_meal": UserArray?.value(forKey: "check_meal") as! Int
                                    ]
                                
            ns.setValue(CurrentUser, forKey: "CurrentUser")
                                ns.synchronize()
                                
                                let deviceToken = MyTools.tools.getDeviceToken()
                                
                                self.PostFcmToken(token: deviceToken!,type: "ios")
                                print(deviceToken)

                                let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = vc
                                appDelegate?.window??.makeKeyAndVisible()
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
    
    func PostFcmToken(token:String,type:String){
        
        if MyTools.tools.connectedToNetwork()
        {
                self.showIndicator()
                MyApi.api.PostFcmToken(token: token, type: "ios")
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                print("success")
                                
                                
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
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
        
    }
    
    
    @IBAction func btnStaticPage(_ sender: UIButton)
    {
        if(sender.tag == 0){
            //privacy
            let vc:SAAboutUs = AppDelegate.storyboard.instanceVC()
            vc.type = "privacy"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            //terms
            let vc:SAAboutUs = AppDelegate.storyboard.instanceVC()
            vc.type = "terms"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
