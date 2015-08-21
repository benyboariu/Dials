//
//  DSUtils.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 21/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit
import DateTools

class DSUtils {
    class func urlEncodeUsingEncoding(string : String) -> String? {
        
        let originalString         = string
        let customAllowedSet       = NSCharacterSet(charactersInString:"!*'\"();:@&=+$,/?%#[]% ").invertedSet
        let escapedString          = originalString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
        return escapedString
    }
    
    class func getStartDate() -> String {
        let dateFormatter           = NSDateFormatter()
        dateFormatter.dateFormat    = "yyyyMMdd'T'HHmmss'Z'"
        
        let date                    = NSDate().dateBySubtractingMonths(3)
        let strStartDate            = dateFormatter.stringFromDate(date)
        
        return strStartDate
    }
    
    class func getEndDate() -> String {
        let dateFormatter           = NSDateFormatter()
        dateFormatter.dateFormat    = "yyyyMMdd'T'HHmmss'Z'"
        
        let date                    = NSDate().dateByAddingYears(1)
        let strEndDate              = dateFormatter.stringFromDate(date)
        
        return strEndDate
    }
    
    class func getCalendarDict(dictData: [String: AnyObject]) -> [String: AnyObject] {
        var dictInfo            = [String: AnyObject]()
        
        if let obj = dictData["uid"] as? String  {
            dictInfo[Constants.Calendar.ID]                     = obj
        }
        
        if let obj = dictData["displayName"] as? String  {
            dictInfo[Constants.Calendar.Name]                   = obj
        }
        
        if let obj = dictData["description"] as? String  {
            dictInfo[Constants.Calendar.Description]            = obj
        }
        
        if let obj = dictData["ctag"] as? String  {
            dictInfo[Constants.Calendar.CTag]                   = obj
        }
        
        if let obj = dictData["syncToken"] as? String  {
            dictInfo[Constants.Calendar.SyncToken]              = obj
        }
        
        if let obj = dictData["url"] as? String  {
            dictInfo[Constants.Calendar.URL]                    = obj
        }
        
        if let obj = dictData["isShared"] as? Bool  {
            dictInfo[Constants.Calendar.IsShared]               = obj
        }
        
        if let obj = dictData["isDefault"] as? Bool  {
            dictInfo[Constants.Calendar.IsDefault]              = obj
        }
        
        if let obj = dictData["isVisible"] as? Bool  {
            dictInfo[Constants.Calendar.IsVisible]              = obj
        }
        
        return dictInfo
    }
}