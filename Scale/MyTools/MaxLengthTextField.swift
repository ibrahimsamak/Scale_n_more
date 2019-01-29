//
//  MaxLengthTextField.swift
//  Injaz
//
//  Created by RAMEZADNAN on 10/28/18.
//  Copyright © 2018 Mostafa. All rights reserved.
//

import Foundation
import UIKit

class MaxLengthTextField: UITextField, UITextFieldDelegate {
    
    private var characterLimit: Int?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = characterLimit else {
                return Int.max
            }
            return length
        }
        set {
            characterLimit = newValue
        }
    }
    
    // 1
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 2
        guard string.characters.count > 0 else {
            return true
        }
        
        // 3
        let currentText = textField.text ?? ""
        // 4
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // 5
        return prospectiveText.characters.count <= maxLength
    }
    
}
