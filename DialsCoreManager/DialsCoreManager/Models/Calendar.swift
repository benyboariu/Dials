//
//  Calendar.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 21/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import RealmSwift

public class Calendar: Object {
    public dynamic var c_id = ""
    public dynamic var c_description = ""
    public dynamic var c_isDefault = false
    public dynamic var c_isShared = false
    public dynamic var c_isVisible = true
    public dynamic var c_name = ""
    public dynamic var c_syncToken = ""
    public dynamic var c_ctag = ""
    public dynamic var c_url = ""
    
    public var toAccount: Account {
        return linkingObjects(Account.self, forProperty: "toCalendar").first!
    }
    
    public let toEvent = List<Event>()
    
    public override static func primaryKey() -> String? {
        return "c_id"
    }
    
    // MARK: - Custom Methods
    
    func addEditCalendarWithDictionary(dictData: [String: AnyObject]) -> Calendar {
        let realm           = try! Realm()
        
        let calendar        = Calendar()
        
        if let obj = dictData[Constants.Calendar.ID] as? String {
            calendar.c_id               = obj
        }
        
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
        
        realm.write { () -> Void in
            realm.add(calendar, update: true)
        }
        
        return calendar
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
