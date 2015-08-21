//
//  DSProfileVC.swift
//  Dials
//
//  Created by Abel Anca on 8/12/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSProfileVC: DSBaseVC, UITextViewDelegate {

    // IBOutlet
    @IBOutlet var txvPrivacyPolicy: UITextView!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var txfFirstName: DSTextField!
    @IBOutlet var txfLastName: DSTextField!
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTxvPrivacyPolicy()
        
        if let user = appDelegate.curUser {
            txfFirstName.text       = user.u_firstName
            txfLastName.text        = user.u_lastName
        }
    }

    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    func setupTxvPrivacyPolicy() {
        
        txvPrivacyPolicy.attributedText = getAttributedTextPrivacyPolicy()
    }
    
    func getAttributedTextPrivacyPolicy() -> NSAttributedString {
        let font                            = UIFont.proximaRegularOfSize(14)!

        let attribLight                     = [NSFontAttributeName : font,
            NSForegroundColorAttributeName : UIColor.dialsWhite()]
        let attribSemibold                  = [NSFontAttributeName : font]
        
        let strAttrib                       = NSMutableAttributedString()
        
        let strBy                           = NSAttributedString(string: "By continuing you agree to our ", attributes: attribLight)
        let strAnd                          = NSAttributedString(string: " and ", attributes: attribLight)
        
        let strTerms                        = NSMutableAttributedString(string: "Terms of Service", attributes: attribSemibold)
        strTerms.addAttribute(NSLinkAttributeName, value: "termsOfService://TermsOfService", range: NSRange(location: 0, length: strTerms.length))
        
        let strPrivacy                      = NSMutableAttributedString(string: "Privacy Policy", attributes: attribSemibold)
        strPrivacy.addAttribute(NSLinkAttributeName, value: "privacyPolicy://PrivacyPolicy", range: NSRange(location: 0, length: strPrivacy.length))
        
        strAttrib.appendAttributedString(strBy)
        strAttrib.appendAttributedString(strTerms)
        strAttrib.appendAttributedString(strAnd)
        strAttrib.appendAttributedString(strPrivacy)
        
        return strAttrib
    }
    
    func presentDSTermsAndPrivacyVC() {
        
        let termsAndPrivacyVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSTermsAndPrivacyVC") as! DSTermsAndPrivacyVC
        self.presentViewController(termsAndPrivacyVC, animated: true, completion: nil)
    }
    
    // MARK: - API Methods
    
    func updateUser_APICall() {
        if let user = appDelegate.curUser {
            var dictParams              = [String: AnyObject]()
            
            dictParams["id"]            = user.u_id
            
            dictParams["phone"]         = user.u_phone
            
            dictParams["firstName"]     = txfFirstName.text
            dictParams["lastName"]      = txfLastName.text
            
            appDelegate.dsAPIManager.updateUser(dictParams, completion: { (success, error, JSON, user) -> Void in
                if let user = user {
                    appDelegate.defaults.setObject(user.u_id, forKey: Constants.UserDefaultsKey.LoggedInUserID)
                    appDelegate.defaults.synchronize()
                    
                    
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                }
            })
        }
    }
    
    // MARK: - Action Methods
    
    @IBAction func btnBack_Action(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnStartDials_Action(sender: AnyObject) {
        updateUser_APICall()
    }
    
    @IBAction func btnDone_Action(sender: AnyObject) {
        updateUser_APICall()
    }
    
    // MARK: - UITextViewDelegate Methods
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
         let termsAndPrivacyVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSTermsAndPrivacyVC") as! DSTermsAndPrivacyVC
        
         let stringScheme = URL.scheme
            if stringScheme == "termsOfService" {
                print("termsOfService", appendNewline: true)
                
                termsAndPrivacyVC.isTerms = true
            }
            else
                if stringScheme == "privacyPolicy" {
                    print("privacyPolicy", appendNewline: true)
                    termsAndPrivacyVC.isTerms = false
                    
            }
        self.presentViewController(termsAndPrivacyVC, animated: true, completion: nil)
        
        return false
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
