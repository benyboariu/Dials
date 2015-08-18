//
//  DSPhoneVerificationVC.swift
//  Dials
//
//  Created by Abel Anca on 8/10/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit
import WYPopoverController
import DialsSyncManager

class DSPhoneVerificationVC: DSBaseVC, DSPopoverVCDelegate, WYPopoverControllerDelegate {
    
    // IBOutlet
    @IBOutlet var lblEnterPhoneNumber: UILabel!
    @IBOutlet var lblInstructions: UILabel!
    @IBOutlet var lblCountry: UILabel!
    
    @IBOutlet var txfPhone: UITextField!
    
    @IBOutlet var btnSendVerifCode: UIButton!
    @IBOutlet var btnCountry: UIButton!
    
    @IBOutlet var imgViewDropdown: UIImageView!
    
    @IBOutlet var viewLineBorderUp: UIView!
    @IBOutlet var viewLineBorderMiddle: UIView!
    @IBOutlet var viewLineBorderDown: UIView!
    
    lazy var popover                = WYPopoverController()
    
    var arrData                     = [[String: AnyObject]]()
    var arrDataSpecial              = [[String: AnyObject]]()
    var dictSelectedCountry         = [String: AnyObject]()
    
    var dictParams                  = [String: AnyObject]()
    
    var strPhoneFinal: String?
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //txfPhone.text = "754823095"
        txfPhone.text = "753017120"
        
        setup()
        
        loadCountries()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    func setup() {
        
        txfPhone.font = UIFont.proximaBoldOfSize(26.0)
        txfPhone.textColor = UIColor.dialsWhite()
        
        btnSendVerifCode.titleLabel?.font = UIFont.proximaBoldOfSize(20.0)
        btnSendVerifCode.backgroundColor = UIColor.dialsBlueAlt()
        btnSendVerifCode.layer.borderWidth = 1
        btnSendVerifCode.layer.cornerRadius = 6
        btnSendVerifCode.setTitleColor(UIColor.dialsWhite(), forState: UIControlState.Normal)
        
        lblEnterPhoneNumber.font = UIFont.proximaBoldOfSize(18.0)
        lblEnterPhoneNumber.textColor = UIColor.dialsWhite()
        
        lblInstructions.font = UIFont.proximaMediumOfSize(13.0)
        lblInstructions.textAlignment = NSTextAlignment.Justified
        lblInstructions.textColor = UIColor.dialsMediumGrey()
        
        viewLineBorderUp.backgroundColor = UIColor.dialsDarkGrey()
        viewLineBorderMiddle.backgroundColor = UIColor.dialsDarkGrey()
        viewLineBorderDown.backgroundColor = UIColor.dialsDarkGrey()
        
        btnSendVerifCode.enabled = true
    }
    
    func loadCountries() {
        if let strJSONPath = NSBundle.mainBundle().pathForResource("Countries", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: strJSONPath) {
                
                do {
                    let parsed = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
                    
                    if let arrParsed = parsed as? [[String: AnyObject]] {
                        self.arrData         = arrParsed
                        
                        var arrAllCountries     = arrParsed
                        var arrSpecial          = [[String: AnyObject]]()
                        
                        if arrParsed.count > 2 {
                            arrSpecial.append(arrAllCountries[0])
                            arrSpecial.append(arrAllCountries[1])
                            arrSpecial.append(arrAllCountries[2])
                            
                            arrAllCountries.removeAtIndex(0)
                            arrAllCountries.removeAtIndex(0)
                            arrAllCountries.removeAtIndex(0)
                        }
                        
                        self.arrData            = arrAllCountries
                        self.arrDataSpecial     = arrSpecial
                        
                        for dictObject in arrParsed {
                            if let strID = dictObject["ISO3166-1-Alpha-2"] as? String {
                                //if strID == "US" {
                                if strID == "RO" {
                                    self.dictSelectedCountry        = dictObject
                                    
                                    setSelectedCountry()
                                }
                            }
                        }
                    }
                }
                catch let error as NSError {
                    // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                    print("A JSON parsing error occurred, here are the details:\n \(error)")
                }
            }
            
        }
    }
    
    func setSelectedCountry() {
        if let strName = dictSelectedCountry["name"] as? String,
            strDial = dictSelectedCountry["Dial"] as? String {
                self.lblCountry.text            = "\(strName)  +\(strDial)"
        }
    }
    
    func pushToNextVC() {
        let confirmPhoneVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSConfirmPhoneVC") as! DSConfirmPhoneVC
        self.navigationController?.pushViewController(confirmPhoneVC, animated: true)
    }
    
    // MARK: - API Methods
    func loginWithPhone() {
        if let strDial = dictSelectedCountry["Dial"] {
            let strTxfPhone         = DSUtils.stripPhoneNumberFormatting(txfPhone.text!)
            
            let strPhone            = "+\(strDial)\(strTxfPhone)"
            
            dictParams["phone"]     = strPhone
            
            appDelegate.dsSyncManager.loginWithEmailAndPass(dictParams, completion: { (success, error, JSON) -> Void in
                if success {
                    let confirmPhoneVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSConfirmPhoneVC") as! DSConfirmPhoneVC
                    self.navigationController?.pushViewController(confirmPhoneVC, animated: true)
                }
                else {
                    let alert = DSUtils.okAlert(error)
                    
                    self.presentViewController(alert, animated: true, completion: { () -> Void in
                    })
                }
            })
        }
        
    }
    
    // MARK: - Action Methods
    
    @IBAction func btnSendVerifCode_Action() {
        loginWithPhone()

    }
    
    @IBAction func btnCountry_Action() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.imgViewDropdown.transform          = CGAffineTransformMakeRotation(CGFloat(-0.99 * M_PI))
        })
        
        self.txfPhone.resignFirstResponder()
        
        let dsPopoverVC                             = self.storyboard?.instantiateViewControllerWithIdentifier("DSPopoverVC") as! DSPopoverVC
        dsPopoverVC.delegate                        = self
        dsPopoverVC.arrData                         = arrData
        dsPopoverVC.arrDataSpecial                  = arrDataSpecial
        
        let grayColor                               = UIColor.color(26, green: 26, blue: 26, alpha: 1)
        
        let popoverBackgroundView                   = WYPopoverBackgroundView.appearance()
        popoverBackgroundView.arrowHeight           = 10
        popoverBackgroundView.arrowBase             = 20
        popoverBackgroundView.tintColor             = grayColor
        popoverBackgroundView.fillTopColor          = grayColor
        popoverBackgroundView.fillBottomColor       = grayColor
        popoverBackgroundView.outerStrokeColor      = UIColor.clearColor()
        popoverBackgroundView.innerStrokeColor      = UIColor.clearColor()
        
        popover                                     = WYPopoverController(contentViewController: dsPopoverVC)
        popover.delegate                            = self
        popover.presentPopoverFromRect(self.btnCountry.bounds, inView: self.btnCountry, permittedArrowDirections: WYPopoverArrowDirection.Up, animated: true)
    }
    
    @IBAction func btnBack_Action(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DSPopoverVCDelegate Methods
    
    func didSelectDataInPopover(obj: AnyObject, sender: AnyObject?) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.imgViewDropdown.transform          = CGAffineTransformMakeRotation(CGFloat(0 * M_PI))
        })
        
        if let selectedObject = obj as? [String: AnyObject] {
            dictSelectedCountry                     = selectedObject
        }
        
        setSelectedCountry()
        
        popover.dismissPopoverAnimated(true)
        
        txfPhone.becomeFirstResponder()
    }
    
    // MARK: - WYPopoverControllerDelegate Methods
    
    func popoverControllerShouldDismissPopover(popoverController: WYPopoverController!) -> Bool {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.imgViewDropdown.transform          = CGAffineTransformMakeRotation(CGFloat(0 * M_PI))
        })
        
        return true
    }
    
    func popoverControllerDidDismissPopover(popoverController: WYPopoverController!) {
        txfPhone.becomeFirstResponder()
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

