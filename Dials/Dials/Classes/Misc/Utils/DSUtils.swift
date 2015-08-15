//
//  Utils.swift
//  Dials
//
//  Created by Beny Boariu on 10/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSUtils {
    class func convertTimeToRadians(date: NSDate) -> Double {
        let degrees                 = self.convertTimeToDegrees(date)
        
        let radians                 = self.convertDegreesToRadians(degrees)
        
        return radians
    }
    
    class func convertTimeToDegrees(date: NSDate) -> Double {
        let calendar                = NSCalendar.currentCalendar()
        
        let dateComeponents         = calendar.components([.Hour, .Minute], fromDate: date)
        
        var hourFraction            = Double(dateComeponents.hour) + Double(dateComeponents.minute) / 60.0
        var degrees                 = 270.0
        
        if dateComeponents.hour == 0 {
            if dateComeponents.minute == 0 {
                degrees             = 270.0
            }
            else {
                if hourFraction < 12.0 {
                    hourFraction    += 12.0
                }
                
                degrees             = fabs((hourFraction * 30.0) - 90.0)
            }
        }
        else
            if dateComeponents.hour == 12 {
                if dateComeponents.minute == 0 {
                    degrees             = 270.5
                }
                else {
                    if hourFraction < 12.0 {
                        hourFraction    += 12.0
                    }
                    
                    degrees             = fabs((hourFraction * 30.0) - 90.0)
                }
            }
            else {
                if hourFraction < 12.0 {
                    hourFraction    += 12.0
                }
                
                degrees             = fabs((hourFraction * 30.0) - 90.0)
        }
        
        return degrees
    }
    
    class func convertDegreesToRadians(degrees: Double) -> Double {
        let radians                 = degrees * M_PI / 180.0
        
        return radians
    }
    
    class func convertTimeToPosition(date: NSDate, radiusOffset: Double, size: CGSize) -> CGPoint {
        let degrees                 = self.convertTimeToDegrees(date)
        
        let point                   = self.convertDegreesToPosition(degrees, radiusOffset: radiusOffset, size: size)
        
        return point
    }
    
    class func convertDegreesToPosition(degrees: Double, radiusOffset: Double, size: CGSize) -> CGPoint {
        let radians                     = self.convertDegreesToRadians(degrees)

        let point                       = self.convertRadiansToPosition(radians, radiusOffset: radiusOffset, size: size)
        
        return point
    }
    
    class func convertRadiansToPosition(radians: Double, radiusOffset: Double, size: CGSize) -> CGPoint {
        let fOffset                     = 0.5
        
        let x                           = ((Double(size.width) * fOffset) + radiusOffset) * cos(radians) + (Double(size.width) * fOffset)
        let y                           = ((Double(size.height) * fOffset) + radiusOffset) * sin(radians) + (Double(size.height) * fOffset)
        
        let point                       = CGPoint(x: x, y: y)
        
        return point
    }
    
    class func convertPositionToAngle(point: CGPoint, size: CGSize) -> CGFloat {
        let origin                      = CGPointMake(size.width / 2 - point.x, size.height / 2 - point.y)
        
        let angle                       = atan2(origin.y, origin.x)
        
        return angle
    }
    
    class func convertPositionToDegrees(point: CGPoint, size: CGSize) -> CGFloat {
        var degrees                     = atan2(size.width / 2 - point.x, size.height / 2 - point.y) * 180.0 / CGFloat(M_PI)
        
        if degrees < 0 {
            degrees                     = -degrees
        }
        else {
            degrees                     = 360 - degrees
        }
        
        return degrees
    }
    
    class func convertPositionToTime(point: CGPoint, size: CGSize) -> NSDate {
        let degrees                     = self.convertPositionToDegrees(point, size: size)
        
        let hours                       = degrees / 360 * 24 / 2
        
        var operand                     = 60.0
        
        var minutes                     = round(modf(Double(hours), &operand) * 60)
        
        if minutes > 57.0 {
            minutes                     = 60
        }
        
        if minutes < 3.0 {
            minutes                     = 0
        }
        
        let calendar                    = NSCalendar.currentCalendar()
        
        let dateComeponents             = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate:NSDate())
        dateComeponents.hour            = Int(hours)
        dateComeponents.minute          = Int(minutes)
        dateComeponents.second          = 0
        
        let finalDate                   = calendar.dateFromComponents(dateComeponents)!
        
        return finalDate
    }
    
    class func translateDrag(x: CGFloat, y: CGFloat, size: CGSize) -> CGPoint {
        let pointOrigin                 = CGPointMake(size.width / 2 - x, size.height / 2 - y)
        let radians                     = atan2(pointOrigin.y, pointOrigin.x)
        
        let newX                        = -(size.width / 2 * cos(radians)) + size.width / 2
        let newY                        = -(size.height / 2 * sin(radians)) + size.height / 2
        
        let newPoint                    = CGPointMake(newX, newY)
        
        return newPoint
    }
    
    class func setTimerAngle(date: NSDate) -> Double {
        let calendar                = NSCalendar.currentCalendar()
        
        let dateComeponents         = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        
        var hourFraction            = Double(dateComeponents.hour) + Double(dateComeponents.minute) / 60.0 + Double(dateComeponents.second) / 3600.0
        var degrees                 = 270.0
        
        if dateComeponents.hour == 0 || dateComeponents.hour == 12 {
            if dateComeponents.minute == 0 {
                degrees             = 270.0
            }
            else {
                if hourFraction < 12.0 {
                    hourFraction    += 12.0
                }
                
                degrees             = fabs((hourFraction * 30.0) - 90.0)
            }
        }
        else{
            if hourFraction < 12.0 {
                hourFraction        += 12.0
            }
            
            degrees                 = fabs((hourFraction * 30.0) - 90.0)
        }
        
        let radians                 = self.convertDegreesToRadians(degrees)
        
        return radians
    }
    
    class func getUtilDate() -> NSDate {
        let calendar                    = NSCalendar.currentCalendar()
        
        let dateComeponents             = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate:NSDate())
        dateComeponents.hour            = 13
        dateComeponents.minute          = 0
        dateComeponents.second          = 0
        
        let dateUtil                    = calendar.dateFromComponents(dateComeponents)!
        
        return dateUtil
    }
    
    class func getCenterOfView(view: UIView) -> CGPoint {
        let center          = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2)
        
        return center
    }
    
    // MARK: - Utils
    
    class func okAlert(message: String?) -> UIAlertController {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
        }))
        
        return alert
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
}
