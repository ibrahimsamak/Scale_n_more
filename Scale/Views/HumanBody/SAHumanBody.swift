//
//  SAHumanBody.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/10/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAHumanBody: UIViewController {

    var isFromLibrary = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }

    @IBAction func btnBody(_ sender: UIButton)
    {
        switch sender.tag {
        case 0:
            let vc: SAHumanBodyDetails1 = AppDelegate.storyboard.instanceVC()
            vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc: SAHumanBodyDetails2 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc: SAHumanBodyDetails3 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc: SAHumanBodyDetails4 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc: SAHumanBodyDetails5 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc: SAHumanBodyDetails6 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc: SAHumanBodyDetails7 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc: SAHumanBodyDetails8 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc: SAHumanBodyDetails9 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 9:
            let vc: SAHumanBodyDetails10 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        case 10:
            let vc: SAHumanBodyDetails11 = AppDelegate.storyboard.instanceVC()
             vc.isFromLibrary = self.isFromLibrary
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

}
