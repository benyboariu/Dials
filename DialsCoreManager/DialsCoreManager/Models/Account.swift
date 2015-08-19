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
    
    public dynamic var toUser: User?
    
    public override static func primaryKey() -> String? {
        return "ac_id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    // MARK: - Custom Methods
    
    func addEditAccountWithDictionary(dictData: [String: AnyObject]) -> Account {
        let realm           = try! Realm()
        
        let account         = Account()
        
        if let strID = dictData["ac_id"] as? String {
            account.ac_id           = strID
        }
        
        if let strEmail = dictData["ac_email"] as? String  {
            account.ac_email        = strEmail
        }
        
        if let strType = dictData["ac_type"] as? String  {
            account.ac_type         = strType
        }
        
        if let strProvider = dictData["ac_provider"] as? String  {
            account.ac_provider     = strProvider
        }
        
        realm.write { () -> Void in
            realm.add(account, update: true)
        }
        
        return account
    }
}
