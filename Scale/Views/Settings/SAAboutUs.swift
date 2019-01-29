//
//  SAAboutUs.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAAboutUs: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var lblTitle: UILabel!
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBlack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    func SetupConfig()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetConfig(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            let items = JSON["items"] as! NSDictionary

                            self.hideIndicator()
                            if(self.type == "About")
                            {
                                let About_us = items.value(forKey: "About_us") as!NSDictionary
                                let translations = About_us.value(forKey: "translations") as! NSArray
                                if(Language.currentLanguage().contains("ar"))
                                {
                                    let content = translations[1] as! NSDictionary
                                    let title = content.value(forKey: "title") as! String
                                    let desc = content.value(forKey: "description") as! String
                                    self.lblTitle.text = "من نحن"
                                    self.webView.loadHTMLString(desc, baseURL: nil)
                                }
                                else{
                                    let content = translations[0] as! NSDictionary
                                    let title = content.value(forKey: "title") as! String
                                    let desc = content.value(forKey: "description") as! String
                                    self.lblTitle.text = "About us"
                                    self.webView.loadHTMLString(desc, baseURL: nil)
                                }
                            }
                            else if(self.type == "terms")
                            {
                                let termsOfUse = items.value(forKey: "termsOfUse") as!NSDictionary
                                let translations = termsOfUse.value(forKey: "translations") as! NSArray
                                if(Language.currentLanguage().contains("ar"))
                                {
                                    let content = translations[1] as! NSDictionary
                                    let title = content.value(forKey: "title") as! String
                                    let desc = content.value(forKey: "description") as! String
                                    self.lblTitle.text = "الشروط والأحكام"

                                    self.webView.loadHTMLString(desc, baseURL: nil)
                                }
                                else{
                                    let content = translations[0] as! NSDictionary
                                    let title = content.value(forKey: "title") as! String
                                    let desc = content.value(forKey: "description") as! String
                                    self.lblTitle.text = "Terms & conditions"

                                    self.webView.loadHTMLString(desc, baseURL: nil)
                                }
                            }
                            else{
                                let privacyPolicy = items.value(forKey: "privacyPolicy") as!NSDictionary
                                let translations = privacyPolicy.value(forKey: "translations") as! NSArray
                                if(Language.currentLanguage().contains("ar"))
                                {
                                    let content = translations[1] as! NSDictionary
                                    let title = content.value(forKey: "title") as! String
                                    let desc = content.value(forKey: "description") as! String
                                    self.lblTitle.text = "سياسة الخصوصية"
                                    self.webView.loadHTMLString(desc, baseURL: nil)
                                }
                                else{
                                    let content = translations[0] as! NSDictionary
                                    let title = content.value(forKey: "title") as! String
                                    let desc = content.value(forKey: "description") as! String
                                    self.lblTitle.text = "privacy Policy"
                                    self.webView.loadHTMLString(desc, baseURL: nil)
                                }
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
