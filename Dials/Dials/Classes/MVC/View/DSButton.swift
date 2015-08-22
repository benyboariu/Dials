//
//  DSButton.swift
//  Dials
//
//  Created by Abel Anca on 8/21/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

@IBDesignable
class DSButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius      = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth       = borderWidth
        }
    }
}
