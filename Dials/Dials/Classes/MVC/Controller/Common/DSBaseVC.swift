//
//  DSBaseVC.swift
//  Dials
//
//  Created by Abel Anca on 8/10/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSBaseVC: UIViewController {

    @IBOutlet var viewTopBar: UIView!
    @IBOutlet var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.font       = UIFont.proximaMediumOfSize(12)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - ViewController Methods
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    // MARK: - API Methods
    
    // MARK: - Action Methods
    
    // MARK: - Memory Management Methods
 
}
