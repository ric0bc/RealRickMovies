//
//  LoginTextFieldsDelegate.swift
//  RealRickMovies
//
//  Created by Mr.X on 03.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import Foundation
import UIKit

class LoginTextFieldsDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
