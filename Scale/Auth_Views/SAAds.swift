//
//  SAAds.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SAAds: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    @objc func runTimedCode()
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = vc
            appDelegate?.window??.makeKeyAndVisible()
        }
        else{
            let vc:SAChoose = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.isStatusBarHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

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
                            self.hideIndicator()
                            let items = JSON["items"] as! NSDictionary
                            let Ads = items.value(forKey: "Ads") as!NSDictionary
                            let img = Ads.value(forKey: "image") as! String
                             self.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
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
    @IBAction func btnSkip(_ sender: UIButton)
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = vc
            appDelegate?.window??.makeKeyAndVisible()
        }
        else{
            let vc:SAChoose = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
