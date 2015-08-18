//
//  User.swift
//  Dials
//
//  Created by Beny Boariu on 18/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import RealmSwift

public class User: Object {
    public dynamic var u_id = ""
    public dynamic var u_accessToken = ""
    public dynamic var u_email = ""
    public dynamic var u_firstName = ""
    public dynamic var u_lastName = ""
    public dynamic var u_phone = ""
    public dynamic var u_smsCode = ""
    
    public var u_name: String {
        return "\(u_firstName) \(u_lastName)"
    }
    
    public override static func primaryKey() -> String? {
        return "u_id"
    }
    
    public override static func ignoredProperties() -> [String] {
        return ["u_name"]
    }
}
