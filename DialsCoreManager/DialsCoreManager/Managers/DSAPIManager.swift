//
//  DSAPIManager.swift
//  DialsCoreManager
//
//  Created by Beny Boariu on 19/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

public class DSAPIManager {
    
    let PRODUCTION              = 1
    
    //>     Creating an Instance of the Alamofire Manager
    var manager = Alamofire.Manager.sharedInstance
    
    public init() {
        setupAlamofireManager(nil)
    }
    
    public func setupAlamofireManager(user: User?) {
        var defaultHeaders                  = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Content-Type"]      = "application/json"
        defaultHeaders["Accept"]            = "application/vnd.dials.v1+json"
        
        if let user = user {
            defaultHeaders["Authorization"]     = user.u_accessToken
        }
        
        let configuration                   = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.manager                        = Alamofire.Manager(configuration: configuration)
    }
    
    // MARK: - USER API
    
    public func canRunVersion(strVersion: String) -> Bool {
        if strVersion == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    public func checkIfEmailAvailable(strEmail: String, completion: (success: Bool, error: String?, JSON: AnyObject?) -> Void) {
        let strURL                      = buildURLWithEndpoint("/users/\(strEmail)")
        
        self.manager
            .request(.GET, strURL, parameters: nil, encoding: .JSON)
            .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                print(JSON.value, appendNewline: true)
                
                if let strResponse = JSON.value as? [String: AnyObject] {
                    if strResponse["active"] != nil {
                        completion(success: false, error: "Email address already used", JSON: nil)
                    }
                    else {
                        completion(success: true, error: nil, JSON: JSON.value!)
                    }
                    
                }
            })
    }
    
    public func signUpWithEmailAndPass(dictParams: [String: AnyObject], completion: (success: Bool, error: String?, JSON: AnyObject?, user: User?) -> Void) {
        let strURL                      = buildURLWithEndpoint("/users")
        
        self.manager
            .request(.POST, strURL, parameters: dictParams, encoding: .JSON)
            .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                print(JSON.value, appendNewline: true)
                
                if let dictResponse = JSON.value as? [String: AnyObject] {
                    if dictResponse["active"] == nil {
                        if let strError = dictResponse["err"] as? String {
                            completion(success: false, error: strError, JSON: nil, user: nil)
                        }
                        else {
                            completion(success: false, error: nil, JSON: nil, user: nil)
                        }
                    }
                    else {
                        let user = User().addEditUserWithDictionary(dictResponse)
                        
                        if let dictLocal = dictResponse["local"] as? [String: AnyObject] {
                            if let strEmail = dictLocal["email"] as? String {
                                var dictAccount                 = [String: AnyObject]()
                                
                                dictAccount["ac_id"]            = strEmail;
                                dictAccount["ac_type"]          = AccountType.Dials.rawValue
                                dictAccount["ac_provider"]      = AccountProvider.Dials.rawValue
                                dictAccount["ac_email"]         = strEmail
                                dictAccount["ac_accessToken"]   = user.u_accessToken
                                
                                let account                     = Account().addEditAccountWithDictionary(dictAccount)
                                
                                let realm                       = try! Realm()
                                realm.write({ () -> Void in
                                    realm.add(account, update: true)
                                    user.toAccount.append(account)
                                })
                                
                                if let dictDialsapp = dictResponse["dialsapp"] as? [String: AnyObject] {
                                    if let dictCalendars = dictDialsapp["calendars"] as? [String: AnyObject] {
                                        DSSyncManager.saveCalendars(dictCalendars, forAccount: account)
                                    }
                                }
                            }
                        }
                        
                        completion(success: true, error: nil, JSON: JSON.value!,  user: user)
                    }
                }
                
            })
    }
    
    public func loginWithEmailAndPass(dictParams: [String: AnyObject], completion: (success: Bool, error: String?, JSON: AnyObject?, user: User?) -> Void) {
        let strURL                      = buildURLWithEndpoint("/login")
        
        self.manager
            .request(.POST, strURL, parameters: dictParams, encoding: .JSON)
            .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                print(JSON.value, appendNewline: true)
                
                if let dictResponse = JSON.value as? [String: AnyObject] {
                    if dictResponse["active"] == nil {
                        if let strError = dictResponse["err"] as? String {
                            completion(success: false, error: strError, JSON: nil, user: nil)
                        }
                        else {
                            completion(success: false, error: nil, JSON: nil, user: nil)
                        }
                    }
                    else {
                        let user = User().addEditUserWithDictionary(dictResponse)
                        
                        if let dictLocal = dictResponse["local"] as? [String: AnyObject] {
                            if let strEmail = dictLocal["email"] as? String {
                                var dictAccount                 = [String: AnyObject]()
                                
                                dictAccount["ac_id"]            = strEmail;
                                dictAccount["ac_type"]          = AccountType.Dials.rawValue
                                dictAccount["ac_provider"]      = AccountProvider.Dials.rawValue
                                dictAccount["ac_email"]         = strEmail
                                dictAccount["ac_accessToken"]   = user.u_accessToken
                                
                                let account                     = Account().addEditAccountWithDictionary(dictAccount)
                                
                                let realm                       = try! Realm()
                                realm.write({ () -> Void in
                                    realm.add(account, update: true)
                                    user.toAccount.append(account)
                                })
                            }
                        }
                        
                        completion(success: true, error: nil, JSON: JSON.value!,  user: user)
                    }
                }
                
            })
    }
    
    public func updateUser(dictParams: [String: AnyObject], completion: (success: Bool, error: String?, JSON: AnyObject?, user: User?) -> Void) {
        if let strID = dictParams["id"] {
            let strURL                      = buildURLWithEndpoint("/users/\(strID)")
            
            self.manager
                .request(.PUT, strURL, parameters: dictParams, encoding: .JSON)
                .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                    print(JSON.value, appendNewline: true)
                    
                    if let dictResponse = JSON.value as? [String: AnyObject] {
                        if dictResponse["active"] == nil {
                            if let strError = dictResponse["err"] as? String {
                                completion(success: false, error: strError, JSON: nil, user: nil)
                            }
                            else {
                                completion(success: false, error: nil, JSON: nil, user: nil)
                            }
                        }
                        else {
                            let user = User().addEditUserWithDictionary(dictResponse)
                            
                            if let dictLocal = dictResponse["local"] as? [String: AnyObject] {
                                if let strEmail = dictLocal["email"] as? String {
                                    var dictAccount                 = [String: AnyObject]()
                                    
                                    dictAccount["ac_id"]            = strEmail;
                                    dictAccount["ac_type"]          = AccountType.Dials.rawValue
                                    dictAccount["ac_provider"]      = AccountProvider.Dials.rawValue
                                    dictAccount["ac_email"]         = strEmail
                                    dictAccount["ac_accessToken"]   = user.u_accessToken
                                    
                                    let account                     = Account().addEditAccountWithDictionary(dictAccount)
                                    
                                    let realm                       = try! Realm()
                                    realm.write({ () -> Void in
                                        realm.add(account, update: true)
                                        user.toAccount.append(account)
                                    })
                                }
                            }
                            
                            completion(success: true, error: nil, JSON: JSON.value!,  user: user)
                        }
                    }
                    
                })
        }
    }
    
    public func requestSMSToken(phone: String, completion: (success: Bool, error: String?, JSON: AnyObject?) -> Void) {
        
        let strUrl                       = buildURLWithEndpoint("/requestSMSToken?phone=\(phone)")
        
        self.manager.request(.GET, strUrl, parameters: nil, encoding: .JSON)
            .responseJSON { (request, response, JSON) -> Void in
                print(JSON.value, appendNewline: true)
                
                if let strResponse = JSON.value as? [String: AnyObject] {
                    if strResponse["err"] != nil {
                        let err = strResponse["err"] as! String
                        
                        completion(success: false, error: err, JSON: nil)
                    }
                    else {
                        completion(success: true, error: nil, JSON: JSON.value)
                    }
                }
        }
    }
    
    public func verifySMSToken(phone: String, token: String, completion: (success: Bool, error: String?, JSON: AnyObject?) -> Void) {
        let strUrl                  = buildURLWithEndpoint("/verifySMSToken?phone=\(phone)&token=\(token)")
        
        self.manager.request(.GET, strUrl, parameters: nil, encoding: .JSON).responseJSON { (request, response, JSON) -> Void in
            print(JSON.value, appendNewline: true)
            
            if let strResponse = JSON.value as? [String: AnyObject] {
                if strResponse["err"] != nil {
                    let err = strResponse["err"] as! String
                    
                    completion(success: false, error: err, JSON: nil)
                }
                else {
                    completion(success: true, error: nil, JSON: JSON.value!)
                }
            }
        }
    }
    
    // MARK: - DIALS API
    
    public func getCalendarsForAccount(account: Account?, completion: (success: Bool, error: String?, JSON: AnyObject?, calendar: Calendar?) -> Void) {
        if let account = account {
            let user        = account.toUser
            
            let strEmail    = DSUtils.urlEncodeUsingEncoding(account.ac_email)!
            
            let strURL      = buildURLWithEndpoint("/users/\(user.u_id)/calendars/\(account.ac_provider)?email=\(strEmail)")
            
            var dictHeaders                     = [String: String]()
            dictHeaders["Authorization"]        = user.u_accessToken
            dictHeaders["x-cal-authtoken"]      = account.ac_accessToken
            
            self.manager
                .request(.GET, strURL, parameters: nil, encoding: .JSON, headers: dictHeaders)
                .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                    print(JSON.value, appendNewline: true)
                    
                    if let dictResponse = JSON.value as? [String: AnyObject] {
                        if let strError = dictResponse["err"] as? String {
                            completion(success: false, error: strError, JSON: nil, calendar: nil)
                        }
                        else {
                            if let dictCalendars = dictResponse["calendars"] as? [String: AnyObject] {
                                DSSyncManager.saveCalendars(dictCalendars, forAccount: account)
                            }
                            
                            completion(success: true, error: nil, JSON: JSON.value!,  calendar: nil)
                        }
                    }
                })
        }
    }
    
    public func getEventsForCalendar(calendar: Calendar?, completion: (success: Bool, error: String?, JSON: AnyObject?, user: User?) -> Void) {
        if let calendar = calendar {
            let account     = calendar.toAccount
            let user        = account.toUser
            
            let strEmail    = DSUtils.urlEncodeUsingEncoding(account.ac_email)!
            let strCalID    = DSUtils.urlEncodeUsingEncoding(calendar.c_id)!
            let strStart    = DSUtils.getStartDate()
            let strEnd      = DSUtils.getEndDate()
            let strURL      = buildURLWithEndpoint("/users/\(user.u_id)/calendars/\(account.ac_provider)/\(strCalID)/events?startDate=\(strStart)&endDate=\(strEnd)&email=\(strEmail)")
            
            var dictHeaders                     = [String: String]()
            dictHeaders["Authorization"]        = user.u_accessToken
            dictHeaders["x-cal-authtoken"]      = account.ac_accessToken
            
            self.manager
                .request(.GET, strURL, parameters: nil, encoding: .JSON, headers: dictHeaders)
                .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                    print(JSON.value, appendNewline: true)
                    
                    if let dictResponse = JSON.value as? [String: AnyObject] {
                        if let strError = dictResponse["err"] as? String {
                            completion(success: false, error: strError, JSON: nil, user: nil)
                        }
                        else {
                            if let dictCalendars = dictResponse["calendars"] as? [String: AnyObject] {
                                DSSyncManager.saveCalendars(dictCalendars, forAccount: account)
                            }
                            
                            completion(success: true, error: nil, JSON: JSON.value!,  user: user)
                        }
                    }
                })
        }
    }
    
    // MARK: - Private Methods
    
    func buildURLWithEndpoint(endpoint: String) -> String {
        
        var url = ""
        let filePath = NSBundle.mainBundle().pathForResource("Environment", ofType: "plist")
        
        let dict = NSDictionary(contentsOfFile: filePath!)
        
        if (PRODUCTION == 1) {
            url = dict?.objectForKey("Production") as! String
        }
        else {
            url = dict?.objectForKey("Debug") as! String
        }
        
        let strURL = "\(url)\(endpoint)"
        
        print("\nAPI Request: \(strURL)\n", appendNewline: true)
        
        return strURL
    }
}