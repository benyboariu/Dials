//
//  DSiCloudLoginVC.swift
//  Dials
//
//  Created by Abel Anca on 8/18/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSiCloudLoginVC: DSBaseVC, UITextViewDelegate {

    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var txfEmail: UITextField!
    @IBOutlet var txfPassword: UITextField!
    @IBOutlet var txvInfo: UITextView!
    
    @IBOutlet var btnSignIn: UIButton!
    
    let colorBlue                      = UIColor.color(0, green: 146, blue: 219, alpha: 1)
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        spinner.hidden                     = true
        
        let color                          = UIColor.color(107, green: 107, blue: 107, alpha: 1)
        
        txfEmail.attributedPlaceholder     = NSAttributedString(string: txfEmail.placeholder!, attributes: [NSForegroundColorAttributeName : color])
        txfPassword.attributedPlaceholder  = NSAttributedString(string: txfPassword.placeholder!, attributes: [NSForegroundColorAttributeName : color])
        
        txvInfo.attributedText             = getAttributedTextPrivacyPolicy()
        txvInfo.editable                   = false
        txvInfo.delaysContentTouches       = false
        txvInfo.textAlignment              = NSTextAlignment.Justified
        txvInfo.scrollEnabled              = true
        txvInfo.showsHorizontalScrollIndicator = false
        txvInfo.showsVerticalScrollIndicator = false
        txvInfo.tintColor                   = colorBlue
        txvInfo.textColor                   = UIColor.whiteColor()
 
    }
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    func getAttributedTextPrivacyPolicy() -> NSAttributedString {
        let font                            = UIFont.proximaRegularOfSize(12)!
        
        
        let attribLight                     = [NSFontAttributeName : font]
        let attribSemibold                  = [NSFontAttributeName : font, NSUnderlineColorAttributeName: colorBlue, NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
        
        let strAttrib                       = NSMutableAttributedString()
        
        let strBy                           = NSAttributedString(string: "We never store your iCloud credentials or send it to our servers. See our ", attributes: attribLight)
        
        let strPrivacy                      = NSMutableAttributedString(string: "Privacy Policy.", attributes: attribSemibold)
        strPrivacy.addAttribute(NSLinkAttributeName, value: "puchHere://PuchHere", range: NSRange(location: 0, length: strPrivacy.length))
        
        strAttrib.appendAttributedString(strBy)
        strAttrib.appendAttributedString(strPrivacy)

        return strAttrib
    }
    
    // MARK: - API Methods
    
    // MARK: - Action Methods
    
    @IBAction func btnBack_Action(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnSignIn_Action(sender: AnyObject) {
    }
    
    // MARK: - UITextViewDelegate Methods
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        
        let termsAndPrivacyVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSTermsAndPrivacyVC") as! DSTermsAndPrivacyVC
        
        let stringScheme = URL.scheme
        if stringScheme == "puchHere" {
            print("puchHere", appendNewline: true)
            
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
