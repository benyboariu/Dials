//
//  DSTextField.swift
//  Dials
//
//  Created by Abel Anca on 8/21/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSTextField: UITextField {

    override func awakeFromNib() {
        if let strPlaceholder = self.attributedPlaceholder?.string {
            
            if let fontPlaceholder = UIFont.proximaBoldOfSize(26.0) {
                
                let placeholderString          = NSAttributedString(string: strPlaceholder, attributes: [NSForegroundColorAttributeName: UIColor.dialsDarkGrey() , NSFontAttributeName : fontPlaceholder])
                
                self.attributedPlaceholder     = placeholderString
            }
        }
    }
}

