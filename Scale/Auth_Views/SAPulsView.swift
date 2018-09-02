//
//  SAPulsView.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
//import PulsingHalo
import MMPulseView
class SAPulsView: UIViewController {

    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewRipple: UIView!
    
    var rippleView: SMRippleView?
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
   
        let fillColor: UIColor? = UIColor.clear
        rippleView = SMRippleView(frame: viewRipple.bounds, rippleColor: UIColor.white, rippleThickness: 0.6, rippleTimer: 0.6, fillColor: fillColor, animationDuration: 4, parentFrame: self.view.frame)
        self.viewRipple.addSubview(rippleView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode()
    {
        let vc:SAAds = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
