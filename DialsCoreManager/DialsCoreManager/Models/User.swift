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
    
    public let toAccount = List<Account>()
    
    public var u_name: String {
        return "\(u_firstName) \(u_lastName)"
    }
    
    public override static func primaryKey() -> String? {
        return "u_id"
    }
    
    /*public override static func ignoredProperties() -> [String] {
        return ["u_name"]
    }*/
    
    // MARK: - Custom Methods
    
    func addEditUserWithDictionary(dictData: [String: AnyObject]) -> User {
        let realm                       = try! Realm()
        
        let user                        = User()
        
        if let strID = dictData["id"] as? String {
            user.u_id               = strID
        }
        
        if let strEmail = dictData["email"] as? String  {
            user.u_email            = strEmail
        }
        
        if let strFirstName = dictData["firstName"] as? String  {
            user.u_firstName        = strFirstName
        }
        
        if let strLastName = dictData["lastName"] as? String  {
            user.u_lastName         = strLastName
        }
        
        if let strToken = dictData["token"] as? String  {
            user.u_accessToken      = strToken
        }
        
        if let strPhone = dictData["phone"] as? String  {
            user.u_phone            = strPhone
        }
        
        realm.write { () -> Void in
            realm.add(user, update: true)
        }
        
        return user
    }
}
