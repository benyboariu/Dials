//
//  UIFont+Utils.swift
//  Dials
//
//  Created by Beny Boariu on 09/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

extension UIFont {
    class func proximaMediumOfSize(size: CGFloat) -> UIFont? {
        return UIFont(name: "ProximaNova-Semibold", size: size)
    }
    
    class func proximaBoldOfSize(size: CGFloat) -> UIFont? {
        return UIFont(name: "ProximaNova-Bold", size: size)
    }
    
    class func proximaRegularOfSize(size: CGFloat) -> UIFont? {
        return UIFont(name: "ProximaNova-Regular", size: size)
    }
    
    class func proximaNumbers(size: CGFloat) -> UIFont? {
        return UIFont(name: "DialsDigits", size: size)
    }
}
