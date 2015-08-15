//
//  ViewController.swift
//  Dials
//
//  Created by Beny Boariu on 08/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DSDialViewDelegate {
    @IBOutlet weak var viewDial: DSDialView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewDial?.delegate      = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        viewDial?.buildDial()
        
        self.loadData()
    }
    
    func loadData() {
        let event               = Event()
        event.e_id              = "1"
        event.e_summarry        = "Test"
        
        let date                = DSUtils.getUtilDate()
        event.e_startDate       = date
        event.e_endDate         = date.dateByAddingTimeInterval(3600)
        
        viewDial?.showEvents([event])
    }
    
    // MARK: - DSDialViewDelegate Methods
    
    func didChangeTimeForEvent(event: Event) {
        let alertController                 = UIAlertController(title: "Event changed", message: "Save changes?", preferredStyle: .Alert)
        let actionCancel                    = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            self.viewDial?.resetDialEventViewStartPosition(event)
            self.viewDial?.deselectEvent()
        })
        
        alertController.addAction(actionCancel)
        
        let actionOk                        = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.viewDial?.saveEventNewTimes(event)
        })
        
        alertController.addAction(actionOk)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    
    // MARK: - Memory Management

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

