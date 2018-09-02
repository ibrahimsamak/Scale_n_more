//
//  SAChoose.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/4/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
//import PulsingHalo
class SAChoose: UIViewController {

    @IBOutlet weak var img: UIImageView!
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
        
//        let halo = PulsingHaloLayer()
//        let point = CGPoint.init(x: img.frame.width/2, y: img.frame.height/2)
//        halo.position = point
//        img.layer.addSublayer(halo)
//        halo.haloLayerNumber = 4
//        halo.radius = 100
//        halo.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6).cgColor
//        halo.start()

    }
    
    
    @IBAction func btnSkip(_ sender: UIButton)
    {
        let vc : rootNavigation = AppDelegate.storyboard.instanceVC()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = vc
        appDelegate?.window??.makeKeyAndVisible()
    }
}
