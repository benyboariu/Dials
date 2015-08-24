//
//  Calendar+Utils.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 22/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import Foundation
import RealmSwift

extension Calendar {
    // MARK: - Custom Methods
    
    func createNewCalendarWithID(strID: String) -> Calendar {
        let calendar                = Calendar()
        calendar.c_id               = strID
        
        return calendar
    }
    
    func getCalendarWithID(strID: String, realm: Realm!) -> Calendar? {
        let predicate               = NSPredicate(format: "c_id = %@", strID)
        let arrCalendars            = realm.objects(Calendar).filter(predicate)
        
        if arrCalendars.count > 0 {
            if let calendar = arrCalendars.first {
                return calendar
            }
        }
        
        return nil
    }
    
    func getExistingOrNewCalendarWithID(strID: String, realm: Realm!) -> Calendar {
        if let calendar = getCalendarWithID(strID, realm: realm) {
            return calendar
        }
        else {
            //>     No calendar found, create new one
            let calendar                = createNewCalendarWithID(strID)
            
            return calendar
        }
    }
    
    func addEditCalendarWithDictionary(dictData: [String: AnyObject], realm: Realm!) -> Calendar {
        var calendar            = Calendar()
        
        if let obj = dictData[Constants.Calendar.ID] as? String {
            calendar                            = self.getExistingOrNewCalendarWithID(obj, realm: realm)
            
            realm.write({ () -> Void in                
                if let obj = dictData[Constants.Calendar.Name] as? String  {
                    calendar.c_name             = obj
                }
                
                if let obj = dictData[Constants.Calendar.Description] as? String  {
                    calendar.c_description      = obj
                }
                
                if let obj = dictData[Constants.Calendar.CTag] as? String  {
                    calendar.c_ctag             = obj
                }
                
                if let obj = dictData[Constants.Calendar.SyncToken] as? String  {
                    calendar.c_syncToken        = obj
                }
                
                if let obj = dictData[Constants.Calendar.URL] as? String  {
                    calendar.c_url              = obj
                }
                
                if let obj = dictData[Constants.Calendar.IsShared] as? Bool  {
                    calendar.c_isShared         = obj
                }
                
                if let obj = dictData[Constants.Calendar.IsDefault] as? Bool  {
                    calendar.c_isDefault        = obj
                }
                
                if let obj = dictData[Constants.Calendar.IsVisible] as? Bool  {
                    calendar.c_isVisible        = obj
                }
                
                realm.add(calendar, update: true)
            })
        }
        
        return calendar
    }
}