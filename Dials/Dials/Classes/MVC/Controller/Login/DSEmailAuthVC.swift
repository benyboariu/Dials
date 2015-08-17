//
//  DSEmailAuthVC.swift
//  Dials
//
//  Created by Abel Anca on 8/10/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit
import Alamofire
import DialsSyncManager

class DSEmailAuthVC: DSBaseVC, UITextFieldDelegate {
    
    var isLoginSelected: Bool? = false
    var existUsername: Bool? = false
    
    // IBOutlet
    @IBOutlet var lblTitleTopBar: UILabel!
    @IBOutlet var lblPassMustBe: UILabel!
    
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnCreateAccount: UIButton!
    
    @IBOutlet var txfUsername: UITextField!
    @IBOutlet var txfPassword: UITextField!
    
    @IBOutlet var viewLineBorder: UIView!
    @IBOutlet var viewLineBorderUp: UIView!
    @IBOutlet var viewLineBorderMiddle: UIView!
    @IBOutlet var viewLineBorderBottom: UIView!
    
    let dsSyncManager               = DSSyncManager()
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        self.txfUsername.text               = "beny@liftoffllc.com"
        self.txfPassword.text               = "qwertyu"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        txfUsername.becomeFirstResponder()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    func setup() {
        
        btnForgotPassword.titleLabel?.font         = UIFont.proximaBoldOfSize(12.0)
        btnForgotPassword.setTitleColor(UIColor.dialsBlue(), forState: UIControlState.Normal)
        
        btnCreate.titleLabel?.font                 = UIFont.proximaBoldOfSize(16.0)
        btnCreate.setTitleColor(UIColor.dialsBlue(), forState: UIControlState.Normal)
        
        btnLogin.titleLabel?.font                  = UIFont.proximaBoldOfSize(16.0)
        btnLogin.setTitleColor(UIColor.dialsDarkGrey(), forState: UIControlState.Normal)
        
        btnCreateAccount.titleLabel?.font          = UIFont.proximaBoldOfSize(20.0)
        btnCreateAccount.backgroundColor           = UIColor.dialsBlueAlt()
        btnCreateAccount.layer.borderWidth         = 1
        btnCreateAccount.layer.cornerRadius        = 6
        btnCreateAccount.setTitleColor(UIColor.dialsWhite(), forState: UIControlState.Normal)
        
        viewLineBorder.backgroundColor             = UIColor.dialsDarkGrey()
        viewLineBorderUp.backgroundColor           = UIColor.dialsDarkGrey()
        viewLineBorderMiddle.backgroundColor       = UIColor.dialsDarkGrey()
        viewLineBorderBottom.backgroundColor       = UIColor.dialsDarkGrey()
        
        
        let color                                  = UIColor.dialsDarkGrey()
        
        txfUsername.font                           = UIFont.proximaMediumOfSize(26.0)
        txfUsername.textColor                      = UIColor.dialsWhite()
        txfUsername.attributedPlaceholder          = NSAttributedString(string: "EMAIL ADDRESS", attributes: [NSForegroundColorAttributeName : color])
        
        txfPassword.font                           = UIFont.proximaMediumOfSize(26.0)
        txfPassword.textColor                      = UIColor.dialsWhite()
        txfPassword.attributedPlaceholder          = NSAttributedString(string: "PASSWORD", attributes: [NSForegroundColorAttributeName : color])
        txfPassword.secureTextEntry                = true
        
        lblPassMustBe.font                         = UIFont.proximaMediumOfSize(12.0)
        lblPassMustBe.textColor                    = UIColor.dialsWhite()
        
        btnForgotPassword.hidden                   = true
    }
    
    func pushToPhoneVerification() {
        
        let phoneVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSPhoneVerificationVC") as! DSPhoneVerificationVC
        self.navigationController?.pushViewController(phoneVC, animated: true)
    }
    
    
    // MARK: - API Methods
    
    func checkUsername_ApiCall(){
        if let strEmail = self.txfUsername.text {
            let strURL                      = "https://calendar-api.dialsapp.com/api/users/\(strEmail)"
            
            let dictHeaders = ["Content-Type": "application/json",
                "Accept": "application/vnd.dials.v1+json"]
            
            Alamofire
                .request(.GET, strURL, parameters: nil, encoding: .JSON, headers: dictHeaders)
                .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                    //print(JSON.value, appendNewline: true)
                    
                    if let strResponse = JSON.value as? [String: AnyObject] {
                        if strResponse["active"] == nil {
                            self.pushToPhoneVerification()
                        }
                        else {
                            
                            let alert = DSUtils.okAlert("Email address already used")
                            self.presentViewController(alert, animated: true, completion: { () -> Void in
                                self.txfUsername.text = ""
                                self.txfUsername.becomeFirstResponder()
                            })
                        }
                        
                    }
                })
        }
    }
    
    func login_APICall() {
        dsSyncManager.loginWithEmailAndPass("local", email: self.txfUsername.text!, password: self.txfPassword.text!) { (success, error, JSON) -> Void in
            if success {
                self.pushToPhoneVerification()
            }
            else {
                let alert = DSUtils.okAlert(error)
                
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                })
            }
        }
        
        /*let dictParameters              = [
            "network": "local",
            "email": self.txfUsername.text!,
            "password": self.txfPassword.text!
        ]
        
        let strURL                      = "https://calendar-api.dialsapp.com/api/login"
        
        appDelegate.manager
            .request(.POST, strURL, parameters: dictParameters, encoding: .JSON)
            .responseJSON(completionHandler: { (request, response, JSON) -> Void in
                print(JSON.value, appendNewline: true)
                
                if let strResponse = JSON.value as? [String: AnyObject] {
                    if strResponse["active"] == nil {
                        
                        let alert = DSUtils.okAlert(strResponse["err"] as? String)
                        self.presentViewController(alert, animated: true, completion: { () -> Void in
                        })
                    }
                    else {
                        self.pushToPhoneVerification()
                    }
                }
                
            })*/
    }
    
    // MARK: - Action Methods
    
    @IBAction func btnBack_Action(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnCreate_Action(sender: AnyObject) {
        
        btnCreate.titleLabel?.font     = UIFont.proximaBoldOfSize(16.0)
        btnCreate.setTitleColor(UIColor.dialsBlue(), forState: UIControlState.Normal)
        
        btnCreateAccount.setTitle("CREATE ACCOUNT", forState: UIControlState.Normal)
        lblTitleTopBar.text            = "CREATE ACCOUNT"
        
        btnLogin.titleLabel?.font      = UIFont.proximaBoldOfSize(16.0)
        btnLogin.setTitleColor(UIColor.dialsDarkGrey(), forState: UIControlState.Normal)
        
        btnForgotPassword.hidden       = true
        lblPassMustBe.hidden           = false
        isLoginSelected                = false
    }
    
    @IBAction func btnLogin_Action(sender: AnyObject) {
        
        btnCreate.titleLabel?.font     = UIFont.proximaBoldOfSize(16.0)
        btnCreate.setTitleColor(UIColor.dialsDarkGrey(), forState: UIControlState.Normal)
        
        btnCreateAccount.setTitle("LOGIN TO DIALS", forState: UIControlState.Normal)
        lblTitleTopBar.text            = "ACCOUNT LOGIN"
        
        btnLogin.titleLabel?.font      = UIFont.proximaBoldOfSize(16.0)
        btnLogin.setTitleColor(UIColor.dialsBlue(), forState: UIControlState.Normal)
        
        btnForgotPassword.hidden       = false
        lblPassMustBe.hidden           = true
        isLoginSelected                = true
    }
    
    @IBAction func btnCreateAccount_Action() {
        
        if txfUsername.text?.utf16.count == 0 {
            
            let alert = DSUtils.okAlert("Email must not be blank")
            
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        else
            if !(DSUtils.isValidEmail(txfUsername.text!)) {
                
                let alert = DSUtils.okAlert("Please enter a valid email")
                
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            else
                if txfPassword.text?.utf16.count == 0 {
                    
                    let alert = DSUtils.okAlert("Password must not be blank")
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                else
                    if txfPassword.text?.utf16.count < 7 {
                        
                        let alert = DSUtils.okAlert("Password must be minimum 7 letters")
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                    }
                    else
                        if isLoginSelected == false {
                            print("Create Account", appendNewline: true)
                            // Create account
                            checkUsername_ApiCall()
                        }
                        else {
                            // Login to Dials
                            print("Login to Dials", appendNewline: true)
                            login_APICall()
        }
    }
    
    
    @IBAction func btnForgotPassword_Action(sender: AnyObject) {
        
        if let url = NSURL(string: "http://calendar.dialsapp.com/forgotPassword") {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: - TextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == txfUsername {
            
            txfUsername.resignFirstResponder()
            txfPassword.becomeFirstResponder()
        }
        else
            if textField == txfPassword {
                txfPassword.resignFirstResponder()
                
                btnCreateAccount_Action()
        }
        return true
    }
    
    
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
