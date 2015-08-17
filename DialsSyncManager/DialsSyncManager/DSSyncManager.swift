//
//  DSSyncManager.swift
//  DialsSyncManager
//
//  Created by Beny Boariu on 17/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import Foundation
import Alamofire

public class DSSyncManager {
    
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
        
    public func loginWithEmailAndPass(network: String, email: String, password: String, completion: (success: Bool, error: String?, JSON: AnyObject?) -> Void) {
        let dictParameters              = [
            "network": network,
            "email": email,
            "password": password
        ]
        
        let strURL                      = "https://calendar-api.dialsapp.com/api/login"
        
        self.manager
            .request(.POST, strURL, parameters: dictParameters, encoding: .JSON)
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
                        //let alert = DSUtils.okAlert(strResponse["err"] as? String)
                        //self.presentViewController(alert, animated: true, completion: { () -> Void in
                        //})
                    }
                    else {
                        completion(success: true, error: nil, JSON: JSON.value!)
                        //self.pushToPhoneVerification()
                    }
                }
                
            })
    }
    
    public func requestSMSToken(phone: String, completion: (success: Bool, error: String?, JSON: AnyObject?) -> Void) {
        
        let strUrl                       = "https://calendar-api.dialsapp.com/api/requestSMSToken?phone=\(phone)"
        
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
    
    public func verifySMSToken(phone: String, token: String, completion: (success: Bool, error: String?, JSON: AnyObject?) -> Void) {
        
        let strUrl                       = "https://calendar-api.dialsapp.com/api/verifySMSToken?phone=\(phone)&token=\(token)"
        
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
}