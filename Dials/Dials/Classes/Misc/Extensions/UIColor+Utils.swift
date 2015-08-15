//
//  UIColor+Utils.swift
//  Dials
//
//  Created by Beny Boariu on 09/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

extension UIColor {
    class func color(red: Double, green: Double, blue: Double, alpha: Double) -> UIColor {
        return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: CGFloat(alpha))
    }
    
    class func dialsWhite() -> UIColor {
        return UIColor(red:230.0/255, green:230.0/255, blue:230.0/255, alpha:1.0)
    }
    
    class func dialsRed() -> UIColor {
        return UIColor(red:247.0/255, green:73.0/255, blue:54.0/255, alpha:1.0)
    }
    
    class func dialsAlertRed() -> UIColor {
        return UIColor(red:181.0/255, green:6.0/255, blue:6.0/255, alpha:1.0)
    }
    
    class func dialsYellow() -> UIColor {
        return UIColor(red:226.0/255, green:209.0/255, blue:0.0/255, alpha:1.0)
    }
    
    class func dialsGreen() -> UIColor {
        return UIColor(red:39.0/255, green:215.0/255, blue:126.0/255, alpha:1.0)
    }
    
    class func dialsBlue() -> UIColor {
        return UIColor(red:0.0/255, green:206.0/255, blue:234.0/255, alpha:1.0)
    }
    
    class func dialsDarkGrey() -> UIColor {
        return UIColor(red:77.0/255, green:77.0/255, blue:77.0/255, alpha:1.0)
    }
    
    class func dialsTickGrey() -> UIColor {
        return UIColor(red:90.0/255, green:90.0/255, blue:90.0/255, alpha:1.0)
    }
    
    class func dialsLightGrey() -> UIColor {
        return UIColor(red:179.0/255, green:179.0/255, blue:179.0/255, alpha:1.0)
    }
    
    class func dialsMediumGrey() -> UIColor {
        return UIColor(red:138.0/255, green:138.0/255, blue:138.0/255, alpha:1.0)
    }
    
    class func dialsSuperDarkGrey() -> UIColor {
        return UIColor(red:15.0/255, green:15.0/255, blue:15.0/255, alpha:1.0)
    }
    
    class func dialsAllDayGrey() -> UIColor {
        return UIColor(red:26.0/255, green:26.0/255, blue:26.0/255, alpha:1.0)
    }
    
    class func dialsMidnight() -> UIColor {
        return UIColor(red:30.0/255, green:32.0/255, blue:100.0/255, alpha:1.0)
    }
    
    class func dialsMidday() -> UIColor {
        return UIColor(red:254.0/255, green:228.0/255, blue:188.0/255, alpha:1.0)
    }
        
    class func dialsBlueAlt() -> UIColor {
        return UIColor(red: 89.0/255, green: 192.0/255, blue: 251.0/255, alpha: 1)
    }
}