//
//  DSDialEventView.swift
//  Dials
//
//  Created by Beny Boariu on 10/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit
import DateTools
import DialsCoreManager

protocol DSDialEventViewDelegate {
    func didTapView(dsDialEventView: DSDialEventView)
    func didPanView(dsDialEventView: DSDialEventView)
}

class DSDialEventView: UIView {
    // MARK: - Outlets
    
    @IBOutlet weak var imgViewIcon: UIImageView?
    @IBOutlet weak var imgViewPicture: UIImageView?
    
    // MARK: - Properties
    
    var delegate: DSDialEventViewDelegate?
    
    var curEvent: Event?
    var image: UIImage?
    var startDate: NSDate?
    var type                = EventType.kEventTypeMeeting
    
    var isEventEndView      = false
    
    var tapGesture          = UITapGestureRecognizer()
    var panGesture          = UIPanGestureRecognizer()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Methods
    
    func setupView(parentView: UIView) {
        if let event = self.curEvent {
            if isEventEndView {
                self.setupPanGesture()
            }
            else {
                self.setupTapGesture()
            }
            
            self.center                     = DSUtils.convertTimeToPosition(event.e_startDate, radiusOffset: Constants.Radius.EventPosition, size:parentView.frame.size)
            
            if isEventEndView {
                self.center                 = DSUtils.convertTimeToPosition(event.e_endDate, radiusOffset: Constants.Radius.EventPosition, size:parentView.frame.size)
            }
            
            let angle                       = DSUtils.convertPositionToAngle(self.center, size:parentView.frame.size)
            self.imgViewIcon?.transform     = CGAffineTransformMakeRotation(angle)
        }
    }
    
    func enablePanning(partner: DSDialEventView) {
        self.setupPanGestureWithPartner(partner)
    }
    
    func disablePanning() {
        self.removePanGestureWithPartner()
    }
    
    // MARK: - Custom Methods
    
    private func calculateSnap(date: NSDate) -> NSDate {
        let calendar                = NSCalendar.currentCalendar()
        
        let dateComeponents         = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate:date)
        
        let minutes                 = dateComeponents.minute
        let remain                  = ceil(Double(minutes % 15))
    
        var newDate                 = date
        
        if remain < 7.5 {
            newDate                 = date.dateBySubtractingSeconds(60 * Int(remain))
        }
        else {
            newDate                 = date.dateByAddingSeconds(60 * (15 - Int(remain)))
        }
        
        let newDateComponents       = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: newDate)
        newDateComponents.second    = 0
        let finalDate               = calendar.dateFromComponents(newDateComponents)
        
        return finalDate!
    }
    
    // MARK: - Setup Gestures Methods
    
    func setupTapGesture() {
        self.tapGesture                         = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        
        self.addGestureRecognizer(self.tapGesture)
    }
    
    func removeTapGesture() {
        self.removeGestureRecognizer(self.tapGesture)
    }
    
    private func setupPanGesture() {
        self.panGesture                         = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.panGesture.maximumNumberOfTouches  = 1
        
        self.addGestureRecognizer(self.panGesture)
    }
    
    private func removePanGesture() {
        self.removeGestureRecognizer(self.panGesture)
    }
    
    private func setupPanGestureWithPartner(partner: DSDialEventView) {
        self.panGesture                         = UIPanGestureRecognizer(target: self, action: "handlePanGestureWithPartner:")
        self.panGesture.maximumNumberOfTouches  = 1
        
        self.removeTapGesture()
        self.addGestureRecognizer(self.panGesture)
    }
    
    private func removePanGestureWithPartner() {
        self.removeGestureRecognizer(self.panGesture)
    }
    
    // MARK: - Action Methods
    
    func handleTapGesture(gesture: UITapGestureRecognizer) {
        self.delegate?.didTapView(self)
    }
    
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let locationInSuperview     = gesture.locationInView(self.superview!)
        
        let newPoint                = DSUtils.translateDrag(locationInSuperview.x, y:locationInSuperview.y, size:self.superview!.frame.size)
        
        self.center                 = newPoint
        
        let angle                       = DSUtils.convertPositionToAngle(self.center, size:self.superview!.frame.size)
        self.imgViewIcon?.transform     = CGAffineTransformMakeRotation(angle)
        
        let newDate                     = DSUtils.convertPositionToTime(self.center, size: self.superview!.frame.size)
        let finalDate                   = self.calculateSnap(newDate)
        print("Final Date: \(finalDate)", appendNewline: true)
        self.center                     = DSUtils.convertTimeToPosition(finalDate, radiusOffset: Constants.Radius.EventPosition, size: self.superview!.frame.size)
        
        self.delegate?.didPanView(self)
    }
    
    func handlePanGestureWithPartner(gesture: UIPanGestureRecognizer) {
        let locationInSuperview     = gesture.locationInView(self.superview!)
        
        let newPoint                = DSUtils.translateDrag(locationInSuperview.x, y:locationInSuperview.y, size:self.superview!.frame.size)
        
        self.center                 = newPoint
        
        let angle                       = DSUtils.convertPositionToAngle(self.center, size:self.superview!.frame.size)
        self.imgViewIcon?.transform     = CGAffineTransformMakeRotation(angle)
        
        let newDate                     = DSUtils.convertPositionToTime(self.center, size: self.superview!.frame.size)
        let finalDate                   = self.calculateSnap(newDate)
        print("Final Date: \(finalDate)", appendNewline: true)
        self.center                     = DSUtils.convertTimeToPosition(finalDate, radiusOffset: Constants.Radius.EventPosition, size: self.superview!.frame.size)
        
        self.delegate?.didPanView(self)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
