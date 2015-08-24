//
//  DSSyncManager.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 19/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

public class DSSyncManager {
    
    class func saveCalendars(dictCalendars: [String: AnyObject], forAccount account: Account) {
        let realm               = try! Realm()
        
        let arrKeys             = dictCalendars.keys.array
        
        for strKey in arrKeys {
            let dictData        = dictCalendars[strKey] as! [String: AnyObject]
            
            var dictCalendar    = DSUtils.getCalendarDict(dictData)
            
            //>     "calendar" is the default Dials calendar
            if strKey == "calendar" {
                dictCalendar[Constants.Calendar.IsDefault]  = true
            }
            
            let calendar        = Calendar().addEditCalendarWithDictionary(dictCalendar, realm: realm)
            
            realm.write({ () -> Void in
                account.toCalendar.append(calendar)
            })
        }
    }
}