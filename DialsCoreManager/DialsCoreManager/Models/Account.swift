//
//  Account.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 19/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import RealmSwift

public enum AccountType: String {
    case Dials = "Dials",
    iCloud = "iCloud",
    Google = "Google"
}

public enum AccountProvider: String {
    case Dials = "dialsapp",
    iCloud = "icloud",
    Google = "google"
}

public class Account: Object {
    public dynamic var ac_id = ""
    public dynamic var ac_type = AccountType.Dials.rawValue
    public dynamic var ac_provider = AccountProvider.Dials.rawValue
    public dynamic var ac_accessToken = ""
    public dynamic var ac_refreshToken = ""
    public dynamic var ac_tokenExpire = NSDate()
    public dynamic var ac_userID = ""
    public dynamic var ac_email = ""
    
    public var toUser: User {
        return linkingObjects(User.self, forProperty: "toAccount").first!
    }
    
    public let toCalendar = List<Calendar>()
    
    public override static func primaryKey() -> String? {
        return "ac_id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    // MARK: - Custom Methods
    
    func addEditAccountWithDictionary(dictData: [String: AnyObject]) -> Account {
        //let realm           = try! Realm()
        
        let account         = Account()
        
        if let obj = dictData["ac_id"] as? String {
            account.ac_id               = obj
        }
        
        if let obj = dictData["ac_email"] as? String  {
            account.ac_email            = obj
        }
        
        if let obj = dictData["ac_type"] as? String  {
            account.ac_type             = obj
        }
        
        if let obj = dictData["ac_provider"] as? String  {
            account.ac_provider         = obj
        }
        
        if let obj = dictData["ac_accessToken"] as? String  {
            account.ac_accessToken      = obj
        }
        
        if let obj = dictData["ac_refreshToken"] as? String  {
            account.ac_refreshToken     = obj
        }
        
        /*realm.write { () -> Void in
            realm.add(account, update: true)
        }*/
        
        return account
    }
}
