//
//  SASignIn.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit

class SASignIn: UIViewController , FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if let error = error
        {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken

        self.GoogleLogin(token: accessToken!)
        print(user!.profile.email)
        print(user!.profile.name)
        print(user!.profile)
    }
   // let token = MyTools.tools.getMyToken()
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
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
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
     
        if(Language.currentLanguage().contains("ar"))
        {
            self.txtEmail.textAlignment  = .right
            self.txtPassword.textAlignment  = .right
            self.btnArrow.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else
        {
            self.txtEmail.textAlignment  = .left
            self.txtPassword.textAlignment  = .left
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnLogin(_ sender: UIButton)
    {
        
        if MyTools.tools.connectedToNetwork()
        {
            if txtEmail.text?.count == 0{
                self.showOkAlert(title: "Error".localized, message: "Please enter your email address".localized)
            }
            if !MyTools.tools.validateEmail(candidate: txtEmail.text!)
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter a valid email address".localized)
            }
            else if (txtPassword.text?.count)! == 0
            {
                self.showOkAlert(title: "Error".localized, message: "Please enter your password".localized)
            }
            else
            {
                self.showIndicator()
                MyApi.api.PostLoginUser(email: txtEmail.text!, password: txtPassword.text!)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                print("success")
                                let UserArray = JSON["items"] as? NSDictionary
                            
                                
                                let ns = UserDefaults.standard
                                
                                let CurrentUser:NSDictionary =
                                    [
        "id":UserArray?.value(forKey: "id") as! Int,
        "access_token":UserArray?.value(forKey: "access_token") as! String,
            "name":UserArray?.value(forKey: "name") as! String,
            "check_meal": UserArray?.value(forKey: "check_meal") as! Int,
            "email":UserArray?.value(forKey: "email") as! String,
         //   "mobile":UserArray?.value(forKey: "mobile") as! String
                                ]
                                
                                ns.setValue(CurrentUser, forKey: "CurrentUser")
                                ns.synchronize()
                let deviceToken = MyTools.tools.getDeviceToken()
                let userEmail = MyTools.tools.getMyemail()
               // let userMobile = MyTools.tools.getMymobile()
                let userName = MyTools.tools.getMyname()
                    
                                self.PostFcmToken(token: deviceToken!,type: "ios")
                                print(deviceToken)

    let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
    let appDelegate = UIApplication.shared.delegate
    appDelegate?.window??.rootViewController = vc
    appDelegate?.window??.makeKeyAndVisible()
                                
                            
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
    
    @IBAction func btnFacebook(_ sender: UIButton)
    {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil
            {
                print("Custom FB Login failed:", err)
                return
            }
           
            let accessToken = FBSDKAccessToken.current()
            let token = (result?.token.tokenString)!

            self.FaceLogin(token:  (result?.token.tokenString)!)
            self.showEmailAddress()
        }
    }
    
    @IBAction func btnGooglePlus(_ sender: UIButton)
    {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.handleCustomGoogleSign()
    }
    
    
    @IBAction func btnTwitter(_ sender: UIButton)
    {
        TWTRTwitter.sharedInstance().logIn() { session, error in
            if (session != nil)
            {
                print(session?.userName)
                
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail { email, error in
                    if (email != nil)
                    {
                        print("signed in as \(session?.userName )");
                    } else {
                        print("error: \(error?.localizedDescription)");
                    }
                }
            }
            else
            {
                print(error?.localizedDescription)
                self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
            }
        }
    }
    
    @objc func handleCustomGoogleSign()
    {
        GIDSignIn.sharedInstance().currentUser
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func handleCustomFBLogin()
    {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err)
                self.showOkAlert(title: "Error", message: "Custom FB Login failed")
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error != nil {
            print(error)
            return
        }
        
        showEmailAddress()
    }

    func showEmailAddress()
    {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email,picture.type(large),gender, birthday"]).start { (connection, result, err) in
            
            if err != nil
            {
                print("Failed to start graph request:", err ?? "")
                return
            }
            let fbDetails = result as! NSDictionary
            print(fbDetails["name"] as! String)
            print(fbDetails["email"] as! String)
            print(fbDetails["gender"] as? String ?? "")
            print(fbDetails["birthday"] as? String ?? "")
            var userID = fbDetails["id"] as! String
            var facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
            
        }
    }
    func FaceLogin(token:String){
        if MyTools.tools.connectedToNetwork()
        {

                self.showIndicator()

                MyApi.api.LoginFB(token: token)
                { (response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let  status = JSON["status"] as? Bool
                            if (status == true)
                            {
                                print("success")
                                let UserArray = JSON["items"] as? NSDictionary
                                let ns = UserDefaults.standard
                                
                                let CurrentUser:NSDictionary =
                                    [
                                        "id":UserArray?.value(forKey: "id") as! Int,
                                        "access_token":UserArray?.value(forKey: "access_token") as? String ?? "",
                                        "name":UserArray?.value(forKey: "name") as? String ?? "",
                                        "check_meal": UserArray?.value(forKey: "check_meal") as? Int  ?? 0
                                ]
                                
                                ns.setValue(CurrentUser, forKey: "CurrentUser")
                                ns.synchronize()
                                
                                let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = vc
                                appDelegate?.window??.makeKeyAndVisible()
                                
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
    func GoogleLogin(token:String)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.LoginGoogle(token: token)
            { (response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let  status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            print("success")
                            let UserArray = JSON["items"] as? NSDictionary
                            let ns = UserDefaults.standard
                            
                            let CurrentUser:NSDictionary =
                                [
                                    "id":UserArray?.value(forKey: "id") as! Int,
                                    "access_token":UserArray?.value(forKey: "access_token") as? String ?? "",
                                    "name":UserArray?.value(forKey: "name") as? String ?? "",
                                    "check_meal": UserArray?.value(forKey: "check_meal") as? Int  ?? 0
                                ]
                            
                            ns.setValue(CurrentUser, forKey: "CurrentUser")
                            ns.synchronize()
                            
                            let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = vc
                            appDelegate?.window??.makeKeyAndVisible()
                            
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
    
    @IBAction func btnSkip(_ sender: UIButton)
    {
        let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = vc
        appDelegate?.window??.makeKeyAndVisible()
    }
}
