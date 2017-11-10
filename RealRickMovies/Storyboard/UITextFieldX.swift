//
//  UITextFieldX.swift
//  RealRickMovies
//
//  Created by Ricky on 10.11.17.
//  Copyright © 2017 Ricky. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldX: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) + height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = UIColor.white
        self.addSubview(borderLine)
        
}}
