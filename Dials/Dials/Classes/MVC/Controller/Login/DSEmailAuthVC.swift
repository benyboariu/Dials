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
    @IBOutlet var btnCreateAccount: DSButton!
    
    @IBOutlet var txfUsername: DSTextField!
    @IBOutlet var txfPassword: DSTextField!
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.txfUsername.text               = "beny@liftoffllc.com"
        self.txfPassword.text               = "qwertyu"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        txfUsername.becomeFirstResponder()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    func pushToPhoneVerification(dictParams: [String: AnyObject]) {
        let phoneVC                 = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSPhoneVerificationVC") as! DSPhoneVerificationVC
        phoneVC.dictParams          = dictParams
        self.navigationController?.pushViewController(phoneVC, animated: true)
    }
    
    // MARK: - API Methods
    
    func checkIfEmailAvailable_ApiCall(){
        if let strEmail = self.txfUsername.text {
            appDelegate.dsAPIManager.checkIfEmailAvailable(strEmail, completion: { (success, error, JSON) -> Void in
                if success {
                    let dictParams          = [
                        "network": "local",
                        "email": self.txfUsername.text!,
                        "password": self.txfPassword.text!,
                        "type": "create"
                    ]
                    
                    self.pushToPhoneVerification(dictParams)
                }
                else {
                    let alert = DSUtils.okAlert(error)
                    
                    self.presentViewController(alert, animated: true, completion: { () -> Void in
                    })
                }
            })
        }
    }
    
    func login_APICall() {
        let dictParams          = [
            "network": "local",
            "email": self.txfUsername.text!,
            "password": self.txfPassword.text!,
            "type": "login"
        ]
        
        appDelegate.dsAPIManager.loginWithEmailAndPass(dictParams) { (success, error, JSON, user) -> Void in
            if success {
                self.pushToPhoneVerification(dictParams)
            }
            else {
                let alert = DSUtils.okAlert(error)
                
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                })
            }
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func btnBack_Action(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnCreate_Action(sender: AnyObject) {
        
        btnCreate.setTitleColor(UIColor.dialsBlue(), forState: UIControlState.Normal)
        
        btnCreateAccount.setTitle("CREATE ACCOUNT", forState: UIControlState.Normal)
        lblTitleTopBar.text            = "CREATE ACCOUNT"
        
        btnLogin.setTitleColor(UIColor.dialsDarkGrey(), forState: UIControlState.Normal)
        
        btnForgotPassword.hidden       = true
        lblPassMustBe.hidden           = false
        isLoginSelected                = false
    }
    
    @IBAction func btnLogin_Action(sender: AnyObject) {

        btnCreate.setTitleColor(UIColor.dialsDarkGrey(), forState: UIControlState.Normal)
        
        btnCreateAccount.setTitle("LOGIN TO DIALS", forState: UIControlState.Normal)
        lblTitleTopBar.text            = "ACCOUNT LOGIN"
        
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
                            checkIfEmailAvailable_ApiCall()
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
