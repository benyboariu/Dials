//
//  DSImportCalendarsVC.swift
//  Dials
//
//  Created by Abel Anca on 8/12/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSImportCalendarsVC: DSBaseVC {

    var isiCloadConected: Bool = false
    var isGoogleConected: Bool = false
    
    @IBOutlet var btnSkip: UIButton!
    
    @IBOutlet var btniCloud: UIButton!
    @IBOutlet var btnCheckiCloud: UIButton!
    @IBOutlet var btnDotsiCloud: UIButton!
    
    @IBOutlet var btnGoogle: UIButton!
    @IBOutlet var btnCheckGoogle: UIButton!
    @IBOutlet var btnDotsGoogle: UIButton!
    
    @IBOutlet var imgViewPhone: UIImageView!
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    // MARK: - Custom Methods
    
    func updateUI() {
        
        if isiCloadConected {
            btnCheckiCloud.selected         = true
            btnDotsiCloud.selected          = true
        }
        else {
            self.btnCheckiCloud.selected    = false
            self.btnDotsiCloud.selected     = false
        }
        
        if isGoogleConected {
            btnCheckGoogle.selected         = true
            btnDotsGoogle.selected          = true
        }
        else {
            btnCheckGoogle.selected         = false
            btnDotsGoogle.selected          = false
        }
        
        if isiCloadConected || isGoogleConected {
            imgViewPhone.highlighted        = true
            
            btnSkip.setTitle("Next", forState: UIControlState.Normal)
        }
        else {
            imgViewPhone.highlighted        = false
        }
    }
    
    func checkExistAccount() {
        
    }
    
    func pushToDSProfileVC() {
        
        let profileVC = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSProfileVC") as! DSProfileVC
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    // MARK: - Action Methods
    
    @IBAction func btnBack_Action(sender: AnyObject) {
         self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnSkip_Action(sender: AnyObject) {
        pushToDSProfileVC()
    }
    
    @IBAction func btniCloud_Action(sender: AnyObject) {
    }
    
    @IBAction func btnGoogle_Action(sender: AnyObject) {
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
