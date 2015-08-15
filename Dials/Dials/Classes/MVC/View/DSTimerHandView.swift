//
//  DSTimerHandView.swift
//  Dials
//
//  Created by Beny Boariu on 11/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSTimerHandView: UIView {
    // MARK: - Outlets
    
    // MARK: - Properties
    
    var tmrUpdate               = NSTimer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Methods
    
    func initTimerHandView(superview: UIView) {
        let imgViewTimerHand            = UIImageView(image: UIImage(named: "timer-hand"))
        self.addSubview(imgViewTimerHand)
        
        let ratio                       = UIScreen.mainScreen().bounds.size.width / 380
        imgViewTimerHand.transform      = CGAffineTransformMakeScale(ratio, ratio)
        
        let degrees                     = DSUtils.setTimerAngle(NSDate())
        self.transform                  = CGAffineTransformMakeRotation(CGFloat(degrees))
        tmrUpdate                       = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateTimerHandView:", userInfo: nil, repeats: true)
    }
    
    func destroyTimer() {
        tmrUpdate.invalidate()
    }
    
    // MARK: - Custom Methods
    
    func updateTimerHandView(timer: NSTimer) {
        let degrees                     = DSUtils.setTimerAngle(NSDate())
        self.transform                  = CGAffineTransformMakeRotation(CGFloat(degrees))
    }
}
