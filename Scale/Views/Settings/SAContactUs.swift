//
//  SAContactUs.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
import MessageUI

class SAContactUs: UIViewController,MFMessageComposeViewControllerDelegate ,MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!

    @IBOutlet weak var txtMsg: UITextView!
    
    var entries : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        lblEmail.text = MyTools.tools.getConfigString("info_email")
        lblPhone.text = MyTools.tools.getConfigString("mobile")
        lblAddress.text = MyTools.tools.getConfigString("address")
        
        if(Language.currentLanguage().contains("ar"))
        {
            self.lblEmail.textAlignment = .right
            self.lblPhone.textAlignment = .right
            self.txtMsg.textAlignment = .right
            self.txtName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.lblAddress.textAlignment = .right
            self.txtMobile.textAlignment = .right
            self.txtMsg.placeholder = "الرسالة"
            self.txtMsg.placeholderColor = UIColor.white
        }
        else
        {
            self.lblEmail.textAlignment = .left
            self.lblPhone.textAlignment = .left
            self.txtMsg.textAlignment = .left
            self.txtName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.lblAddress.textAlignment = .left
            self.txtMobile.textAlignment = .left

            self.txtMsg.placeholder = "Message"
            self.txtMsg.placeholderColor = UIColor.white
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
    
    @IBAction func btnAdd(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            if txtName.text?.count == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your name".localized)
            }
            else if txtMobile.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your phone number".localized)
            }
            else if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email address".localized)
            }
            else if !MyTools.tools.validateEmail(candidate: txtEmail.text!){
                self.showOkAlert(title: "Error".localized, message: "Please enter valid email address".localized)
            }
            else if txtMsg.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your message".localized)
            }
            else{
                self.showIndicator()
                MyApi.api.PostContact(fullname: txtName.text!, email: txtEmail.text!, comment: txtMsg.text!, mobile: txtMobile.text!) { (response, error) in
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
            }
        }
        else{
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    
    @objc func call2()
    {
        if let url = URL(string: "tel://\([self.lblPhone.text!)")
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func sendEmail()
    {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.lblEmail.text!])
            mail.setMessageBody("<p></p>", isHTML: true)
            
            present(mail, animated: true)
        }
        else {
            
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func openMap(_ sender: UIButton)
    {
        let lat1 : Double = Double(MyTools.tools.getConfigString("latitude"))!
        let lng1 : Double = Double(MyTools.tools.getConfigString("longitude"))!
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat1, longitude: lng1)))
        destination.name = MyTools.tools.getConfigString("address")
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func btnEmail(_ sender: UIButton)
    {
        self.sendEmail()
    }
    
    @IBAction func btnphone(_ sender: UIButton)
    {
        self.call2()
    }

}
