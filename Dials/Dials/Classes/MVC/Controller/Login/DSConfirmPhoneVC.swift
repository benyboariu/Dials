//
//  DSConfirmPhoneVC.swift
//  Dials
//
//  Created by Abel Anca on 8/11/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSConfirmPhoneVC: DSBaseVC, UITextFieldDelegate {

    //IBOutlet
    
    @IBOutlet var txfNuber: UITextField!
    
    @IBOutlet var btnSingIn: UIButton!
    @IBOutlet var btnResendCode: UIButton!
    
    @IBOutlet var lblEnterCode: UILabel!
    
    @IBOutlet var viewLineBorderTop: UIView!
    @IBOutlet var viewLineBorderBottom: UIView!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var strPhone: String?
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    
    // MARK: - Custom Methods
    func setup() {
        
        txfNuber.font = UIFont.proximaMediumOfSize(26.0)
        txfNuber.textColor = UIColor.dialsWhite()
        txfNuber.becomeFirstResponder()
        
        btnSingIn.titleLabel?.font = UIFont.proximaBoldOfSize(20.0)
        btnSingIn.backgroundColor = UIColor.dialsBlue()
        btnSingIn.layer.borderWidth = 1
        btnSingIn.layer.cornerRadius = 6
        btnSingIn.setTitleColor(UIColor.dialsWhite(), forState: UIControlState.Normal)
        
        btnResendCode.titleLabel?.font = UIFont.proximaMediumOfSize(14.0)
        btnResendCode.setTitleColor(UIColor.dialsBlueAlt(), forState: UIControlState.Normal)
        
        lblEnterCode.font = UIFont.proximaBoldOfSize(18.0)
        lblEnterCode.textColor = UIColor.dialsWhite()
        
        viewLineBorderBottom.backgroundColor = UIColor.darkGrayColor()
        viewLineBorderTop.backgroundColor = UIColor.darkGrayColor()
        
        spinner.hidden = true
    }
    
    func pushToNextVC() {
        let importCalendarsVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSImportCalendarsVC") as! DSImportCalendarsVC
        self.navigationController?.pushViewController(importCalendarsVC, animated: true)
    }

    // MARK: - API Methods
    func loginWithPhone() {
        
        if let strToken = txfNuber.text {
            if let strPhoneNumber = strPhone {
                appDelegate.dsAPIManager.verifySMSToken(strPhoneNumber, token: strToken, completion: { (success, error, JSON) -> Void in
                    if success {
                        self.pushToNextVC()
                        
                    }
                    else {
                        let alert = DSUtils.okAlert("There was an error confirming your code. Please try again or request a new code.")
                        
                        self.presentViewController(alert, animated: true, completion: { () -> Void in
                        })
                    }
                })
            }
        }
    }
    
    func resendCode() {
        
        if let strPhoneNumber = strPhone {
            appDelegate.dsAPIManager.requestSMSToken(strPhoneNumber, completion: { (success, error, JSON) -> Void in
                if success {
                    print("The code was send again", appendNewline: true)
                    
                }
                else {
                    let alert = DSUtils.okAlert("There was an error requesting your new code. Please try again.")
                    
                    self.presentViewController(alert, animated: true, completion: { () -> Void in
                    })
                }
            })
        }
    }

    // MARK: - Action Methods
    @IBAction func btnBack_Action(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSingIn_Action() {
        loginWithPhone()
    }
    
    @IBAction func btnResendCode_Action() {
        
        let alert = DSUtils.okAlert("We're sending you a new verification code.")
        
        self.presentViewController(alert, animated: true, completion: { () -> Void in
            self.resendCode()
        })
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
