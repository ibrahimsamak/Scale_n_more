//
//  SAHome.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAHome: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnWorkout(_ sender: UIButton) {
        
    }
    
    @IBAction func btnResturant(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSettings(_ sender: UIButton)
    {
        let vc:SASettings = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnScale(_ sender: UIButton)
    {
        let checkMealPackage = MyTools.tools.checkMealPackage()
        if(checkMealPackage == 0){
            let vc:SAResturantPackages = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc:SAScaleResturant = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
