//
//  DSLandingVC.swift
//  Dials
//
//  Created by Abel Anca on 8/10/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSLandingVC: UIViewController {
    
    var user  = false
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if user == false {
            showDialsVC()
        }
        else {
            showIntroPageVC()
        }
    }
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    func showIntroPageVC() {
        let navC        = appDelegate.storyboardLogin.instantiateViewControllerWithIdentifier("DSIntroPageVC_NC") as! UINavigationController
        self.navigationController?.presentViewController(navC, animated: true, completion: nil)
    }
    
    func showDialsVC() {
        let dialsVC         = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.navigationController?.pushViewController(dialsVC, animated: false)
    }
    
    // MARK: - API Methods
    
    // MARK: - Action Methods
    
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
