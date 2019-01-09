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
import Firebase
import UserNotifications
import BRYXBanner


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    let gcmMessageIDKey = "gcm.message_id"

    public var mainRootNav: UINavigationController?
    static let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    var window: UIWindow?
    var entries : NSDictionary!
    
    
    override init()
    {
        super.init()
        UIApplication.shared.registerForRemoteNotifications()
        FirebaseApp.configure()
        //Database.database().isPersistenceEnabled = false
    }
    
    
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

        
        Localizer.DoTheExchange()
        Fabric.with([Crashlytics.self])
        Fabric.with([TWTRTwitter.self])

        IQKeyboardManager.shared.enable = true
        TWTRTwitter.sharedInstance().start(withConsumerKey:"wwy1mmNFz7xRm1a0eFyGqe8mJ", consumerSecret:"ptERx9F4XbgpFnmfvIGjC7HEacRlzQgtEA8gqDIdeLd8DqorRz")
        
       GIDSignIn.sharedInstance().clientID = "528735384539-htglau916o25oakkbvmeg10ggcco6nfa.apps.googleusercontent.com"
       GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
        //self.setupView()
        self.SetupConfig()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        application.applicationIconBadgeNumber = 0

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

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        let userInfo = notification.request.content.userInfo
        
        //clicked
        
        let state = UIApplication.shared.applicationState
        
        if state == .active {
            if let aps = userInfo["aps"] as? [String:Any] {
                if let alert = aps["alert"] as? [String:Any] {
                    let body = alert["body"] as? String ?? ""
                    let title = alert["title"] as? String ?? ""
                    let banner = Banner(title: title, subtitle: body, image: nil, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                    banner.dismissesOnSwipe = true
                    
                    //                    print(convertToDictionary(text: alert["loc-key"] as! String) as Any)
                    
                    if alert["loc-key"] == nil {
                        banner.show(duration: 3.0)
                        return
                    }
                    
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey]
        {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().subscribe(toTopic: "/topics/scalenmore")
        
        if InstanceID.instanceID().token() != nil
        {
            let fcmToken = InstanceID.instanceID().token() as! String
            UserDefaults.standard.setValue(fcmToken, forKey: "deviceToken")
            print(fcmToken)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //        Messaging.messaging().subscribe(toTopic: "/topics/testTopic")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
       // UserDefaults.standard.setValue(fcmToken, forKey: "deviceToken")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage)
    {
        
    }
}

