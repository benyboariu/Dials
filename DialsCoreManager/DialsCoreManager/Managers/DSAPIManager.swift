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
        setupAlamofireManager()
    }
    
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
    
    public func loginWithEmailAndPass(dictParams: [String: AnyObject], completion: (success: Bool, error: String?, JSON: AnyObject?) -> Void) {
        let strURL                      = buildURLWithEndpoint("/login")
        
        self.manager
            .request(.POST, strURL, parameters: dictParams, encoding: .JSON)
            .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                print(JSON.value, appendNewline: true)
                
                if let strResponse = JSON.value as? [String: AnyObject] {
                    if strResponse["active"] == nil {
                        if let strError = strResponse["err"] as? String {
                            completion(success: false, error: strError, JSON: nil)
                        }
                        else {
                            completion(success: false, error: nil, JSON: nil)
                        }
                    }
                    else {
                        
                        
                        
                        completion(success: true, error: nil, JSON: JSON.value!)
                    }
                }
                
            })
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
        
        let strUrl                       = buildURLWithEndpoint("/verifySMSToken?phone=\(phone)&token=\(token)")
        
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
    
    // MARK: - Private Methods
    
    func setupAlamofireManager() {
        var defaultHeaders                  = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Content-Type"]      = "application/json"
        defaultHeaders["Accept"]            = "application/vnd.dials.v1+json"
        
        let configuration                   = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.manager                        = Alamofire.Manager(configuration: configuration)
    }
    
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
        
        return strURL
    }
}