//
//  VCformassege.swift
//  Scale
//
//  Created by ramez adnan on 29/01/2019.
//  Copyright © 2019 ibrahim M. samak. All rights reserved.
//

import UIKit

class VCformassege: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnHome(_ sender: UIButton)
    {
        self.navigationController?.popToRoot(animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.pop(animated: true)
    }
    
}
