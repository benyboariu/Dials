//
//  Event.swift
//  Dials
//
//  Created by Beny Boariu on 10/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import RealmSwift

enum EventType: Int {
    case kEventTypeMeeting = 1, kEventTypeCall, kEventTypeTask
}

class Event: Object {
    dynamic var e_id = ""
    dynamic var e_idLocal = ""
    dynamic var e_description = ""
    dynamic var e_summarry = ""
    dynamic var e_startDate = NSDate()
    dynamic var e_endDate = NSDate()
    var e_type = EventType.kEventTypeTask
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
