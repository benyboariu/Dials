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
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
