//
//  ViewController.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/2/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    
}

