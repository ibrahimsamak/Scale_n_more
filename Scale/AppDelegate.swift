//
//  AppDelegate.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/2/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Crashlytics

import Fabric
import GoogleSignIn
import FBSDKCoreKit
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    public var mainRootNav: UINavigationController?
    static let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var window: UIWindow?
    var entries : NSDictionary!
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        
        print("Successfully logged into Google", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
            let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
            GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        
       FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        
      TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        
        return true
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])
        Fabric.with([TWTRTwitter.self])

        IQKeyboardManager.shared.enable = true
        TWTRTwitter.sharedInstance().start(withConsumerKey:"wwy1mmNFz7xRm1a0eFyGqe8mJ", consumerSecret:"ptERx9F4XbgpFnmfvIGjC7HEacRlzQgtEA8gqDIdeLd8DqorRz")
        
       GIDSignIn.sharedInstance().clientID = "528735384539-htglau916o25oakkbvmeg10ggcco6nfa.apps.googleusercontent.com"
       GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.setupView()
        self.SetupConfig()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func setupView()
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "rootNavigation") as? rootNavigation
            if let window = self.window
            {
                window.rootViewController = tabBarController
                self.window?.makeKeyAndVisible()
            }
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = storyboard.instantiateViewController(withIdentifier: "SARootBegin") as? SARootBegin
            if let window = self.window {
                window.rootViewController = rootController
                //self.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    func SetupConfig()
    {
        if MyTools.tools.connectedToNetwork()
        {
            MyApi.api.GetConfig(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as? Bool
                        if (status == true)
                        {
                            let items = JSON["items"] as! NSDictionary
                            let Setting = items.value(forKey: "Setting") as! NSDictionary
                            let Country = items.value(forKey: "Country") as! NSArray
                            UserDefaults.standard.setValue(Country, forKey: "Country")
                       
                            for (key,value) in Setting {
                                print("\(key) = \(value)")
                                let val = value as? String ?? ""
                                let ns = UserDefaults.standard
                                ns.setValue(val, forKey: key as! String)
                                ns.synchronize()
                            }
                        }
                        else
                        {
                            
                        }
                    }
                    else
                    {
                        
                    }
                    
                }
                else
                {
                    
                }
            }
        }
        else
        {
            
        }
    }
    
}

