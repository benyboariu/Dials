//
//  User+Utils.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 22/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import Foundation
import RealmSwift

extension User {
    // MARK: - Custom Methods
    
    func createNewUserWithID(strID: String) -> User {
        let user                    = User()
        user.u_id                   = strID
        
        return user
    }
    
    func getUserWithID(strID: String, realm: Realm!) -> User? {
        let predicate               = NSPredicate(format: "u_id = %@", strID)
        let arrUsers                = realm.objects(User).filter(predicate)
        
        if arrUsers.count > 0 {
            if let user = arrUsers.first {
                return user
            }
        }
        
        return nil
    }
    
    func getExistingOrNewUserWithID(strID: String, realm: Realm!) -> User {
        if let user = getUserWithID(strID, realm: realm) {
            return user
        }
        else {
            //>     No user found, create new one
            let user                    = createNewUserWithID(strID)
            
            return user
        }
    }
    
    func addEditUserWithDictionary(dictData: [String: AnyObject], realm: Realm!) -> User {        
        var user        = User()
        
        if let strID = dictData["id"] as? String {
            realm.write { () -> Void in
                user                        = self.getExistingOrNewUserWithID(strID, realm: realm)
                
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
                
                realm.add(user, update: true)
            }
        }
        
        return user
    }
}