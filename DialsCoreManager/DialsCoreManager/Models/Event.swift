//
//  Event.swift
//  Dials
//
//  Created by Beny Boariu on 10/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import RealmSwift

public enum EventType: Int {
    case kEventTypeMeeting = 1, kEventTypeCall, kEventTypeTask
}

public class Event: Object {
    public dynamic var e_id = ""
    public dynamic var e_idLocal = ""
    public dynamic var e_description = ""
    public dynamic var e_summarry = ""
    public dynamic var e_startDate = NSDate()
    public dynamic var e_endDate = NSDate()
    public dynamic var e_type = EventType.kEventTypeTask.rawValue
    
    public override static func primaryKey() -> String? {
        return "e_id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
