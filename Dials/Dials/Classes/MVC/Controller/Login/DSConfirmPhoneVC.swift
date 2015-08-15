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
    
    func pushToDSImportCalendarsVC() {
        let importCalendarsVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSImportCalendarsVC") as! DSImportCalendarsVC
        self.navigationController?.pushViewController(importCalendarsVC, animated: true)
    }

    // MARK: - Action Methods
    @IBAction func btnBack_Action(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSingIn_Action() {
    }
    
    @IBAction func btnResendCode_Action() {
        
        pushToDSImportCalendarsVC()
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
