//
//  SAResturantPackageDetails.swift
//  Scale
//
//  Created by ibrahim M. samak on 8/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAResturantPackageDetails: UIViewController  {

    @IBOutlet weak var txtNote: UILabel!

    var details = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.txtNote.text = details
        if(Language.currentLanguage().contains("ar")){
            self.txtNote.textAlignment = .right
        }
        else{
            self.txtNote.textAlignment = .left
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnClose(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
