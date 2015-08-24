//
//  Account+Utils.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 22/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import Foundation
import RealmSwift

extension Account {
    // MARK: - Custom Methods
    
    func createNewAccountWithID(strID: String) -> Account {
        let account                 = Account()
        account.ac_id               = strID
        
        return account
    }
    
    func getAccountWithID(strID: String, realm: Realm!) -> Account? {
        let predicate               = NSPredicate(format: "ac_id = %@", strID)
        let arrAccounts             = realm.objects(Account).filter(predicate)
        
        if arrAccounts.count > 0 {
            if let account = arrAccounts.first {
                return account
            }
        }
        
        return nil
    }
    
    func getExistingOrNewAccountWithID(strID: String, realm: Realm!) -> Account {
        if let account = getAccountWithID(strID, realm: realm) {
            return account
        }
        else {
            //>     No account found, create new one
            let account                 = createNewAccountWithID(strID)
            
            return account
        }
    }
    
    func addEditAccountWithDictionary(dictData: [String: AnyObject], realm: Realm!) -> Account {
        var account         = Account()
        
        if let obj = dictData["ac_id"] as? String {
            account                         = self.getExistingOrNewAccountWithID(obj, realm: realm)
            
            realm.write({ () -> Void in                
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
                
                realm.add(account, update: true)
            })
        }

        return account
    }
}
