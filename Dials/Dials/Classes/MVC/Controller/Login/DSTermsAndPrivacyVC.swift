//
//  DSTermsAndPrivacyVC.swift
//  Dials
//
//  Created by Abel Anca on 8/14/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSTermsAndPrivacyVC: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var btnBack: UIButton!
    
    var isTerms: Bool?
    
    // ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isTerms == true {
            if let url = NSURL(string: "http://www.dialsapp.com/terms_app.html") {
                webView.loadRequest(NSURLRequest(URL: url))
            }
        }
        else {
            if let url = NSURL(string: "http://dialsapp.com/privacy.html") {
                webView.loadRequest(NSURLRequest(URL: url))
            }
        }
        
        
        print(isTerms, appendNewline: true)
    }
    
    // MARK: - Custom Methods
    
    func updateUI() {
        btnBack.titleLabel?.font = UIFont.proximaMediumOfSize(12.0)
        btnBack.setTitleColor(UIColor.dialsBlueAlt(), forState: UIControlState.Normal)
    }
    
    
    // MARK: -Action Methods
    @IBAction func btnBack_Action(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
    // MARK: - memory Management Methods
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
