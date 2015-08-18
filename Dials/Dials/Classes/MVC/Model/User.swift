//
//  User.swift
//  Dials
//
//  Created by Beny Boariu on 18/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import RealmSwift

class User: Object {
    dynamic var u_id = ""
    dynamic var u_accessToken = ""
    dynamic var u_email = ""
    dynamic var u_firstName = ""
    dynamic var u_lastName = ""
    dynamic var u_phone = ""
    dynamic var u_smsCode = ""
    
    var u_name: String {
        return "\(u_firstName) \(u_lastName)"
    }
    
    override static func primaryKey() -> String? {
        return "u_id"
    }
    
    
    
// Specify properties to ignore (Realm won't persist these)
    
    override static func ignoredProperties() -> [String] {
        return ["u_name"]
    }
}
