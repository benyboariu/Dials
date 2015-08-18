//
//  DialView.swift
//  Dials
//
//  Created by Beny Boariu on 08/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit
import QuartzCore
import RealmSwift
import DialsCoreManager

protocol DSDialViewDelegate {
    func didChangeTimeForEvent(event: Event)
}

class DSDialView: UIView, DSDialEventViewDelegate {
    
    var delegate: DSDialViewDelegate?
    
    var viewStroke: AngleGradientBorderView?
    var viewInnerBackground: UIView?
    var btnAddNew: UIButton?
    var eventDurationLayer          = CAShapeLayer()
    
    var intervalStartEnd            = 0.0
    var arrTicks                    = [UIView]()
    var arrDialEventViews           = [DSDialEventView]()
    
    var tapToDeselectGesture        = UITapGestureRecognizer()
    
    var newStartDate                = NSDate()
    var newEndDate                  = NSDate()
    
    var dialEventViewStart: DSDialEventView?
    var dialEventViewEnd: DSDialEventView?
    
    var timerHandView: DSTimerHandView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.buildDial()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.buildDial()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Public Methods
    
    func buildDial() {
        self.clearDial()
        
        self.setupDial()
        
        self.addClockTicks()
        
        self.addStroke()
        
        self.addTimerHand()
        
        self.addInnerBackground()
        
        self.addCreateNewEventButton()
        
        self.bringEventViewsToFront()
    }
    
    func showEvents(arrEvents: [Event]) {
        for event in arrEvents {
            let dsDialEventView         = DSDialEventView.loadFromNibNamed("DSDialEventView") as! DSDialEventView
            dsDialEventView.curEvent    = event
            dsDialEventView.frame       = CGRectMake(0.0, 0.0, CGFloat(Constants.Sizes.EventView), CGFloat(Constants.Sizes.EventView))
            dsDialEventView.delegate    = self
            dsDialEventView.setupView(self)
            
            self.addSubview(dsDialEventView)
            
            self.arrDialEventViews.append(dsDialEventView)
        }
    }
    
    func saveEventNewTimes(event: Event) {
        appDelegate.realm.write { () -> Void in
            event.e_startDate           = self.newStartDate
            event.e_endDate             = self.newEndDate
        }
        
        print("New Start: \(event.e_startDate)", appendNewline: true)
        print("New End: \(event.e_endDate)", appendNewline: true)
        
        dialEventViewStart?.center      = DSUtils.convertTimeToPosition(
            event.e_startDate,
            radiusOffset: Constants.Radius.EventPosition,
            size: self.frame.size)
        
        deselectEvent()
    }
    
    
    
    // MARK: - Build Screen Methods
    
    private func setupDial() {
        self.backgroundColor        = UIColor.blackColor()
    }
    
    private func clearDial() {
        for view in arrTicks {
            view.removeFromSuperview()
        }
        
        viewStroke?.removeFromSuperview()
        viewStroke             = nil
        
        viewInnerBackground?.removeFromSuperview()
        viewInnerBackground    = nil
        
        timerHandView?.removeFromSuperview()
        
        btnAddNew?.removeFromSuperview()
    }
    
    private func addStroke() {
        let fOffset                 = CGFloat(Constants.Offset.AMPMStroke)
        let newRect                 = CGRectMake(fOffset, fOffset, self.frame.size.width - 2 * fOffset, self.frame.size.height - 2 * fOffset)
        
        let arrGradientColors       = [UIColor.dialsMidnight().CGColor, UIColor.dialsMidday().CGColor]
        
        let viewStroke              = AngleGradientBorderView(frame: newRect, borderColors: arrGradientColors, borderWidth: 3.0)
        viewStroke.backgroundColor  = UIColor.clearColor()
        viewStroke.transform        = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        self.addSubview(viewStroke)
        
        self.viewStroke             = viewStroke
    }
    
    private func addInnerBackground() {
        let fOffset                 = CGFloat(Constants.Offset.InnerBackground)
        let rect                    = CGRectMake(fOffset, fOffset, self.frame.size.width - 2 * fOffset, self.frame.size.height - 2 * fOffset)
        
        let viewInnerBackground                     = UIView(frame: rect)
        viewInnerBackground.backgroundColor         = UIColor.dialsAllDayGrey()
        viewInnerBackground.layer.cornerRadius      = rect.size.width / 2
        viewInnerBackground.layer.masksToBounds     = true
        self.addSubview(viewInnerBackground)
        
        self.viewInnerBackground    = viewInnerBackground
    }
    
    private func addClockTicks() {
        //>     Will be used to show 3, 6, 9 and 12 labels
        var h                       = 3
        
        for var i = 0.0; i < 360.0; i += 7.5 {
            var viewTick            = UIView()
            var lblTick             = UILabel()
            
            if Int(fmod(i, 90.0)) == 0 {
                lblTick                 = UILabel(frame: CGRectMake(0.0, 0.0, 30, 15.0))
                lblTick.textColor       = UIColor.dialsMediumGrey()
                lblTick.font            = UIFont.proximaBoldOfSize(15.0)
                lblTick.textAlignment   = .Center
                lblTick.text            = "\(h)"
                lblTick.center          = DSUtils.convertDegreesToPosition(
                    Double(i),
                    radiusOffset: Constants.Radius.ClockPosition,
                    size: self.frame.size)
                
                self.addSubview(lblTick)
                arrTicks.append(lblTick)
                
                h                       = h + 3
            }
            else
                if Int(fmod(i, 30.0)) == 0 {
                    viewTick                            = UIView(frame: CGRectMake(0, 0, 10, 2))
                    viewTick.layer.shouldRasterize      = true
                    viewTick.backgroundColor            = UIColor.dialsDarkGrey()
                    viewTick.transform                  = CGAffineTransformMakeRotation(CGFloat(i) * CGFloat(M_PI) / 180.0)
                    
                    viewTick.center                     = DSUtils.convertDegreesToPosition(
                        Double(i),
                        radiusOffset: Constants.Radius.ClockPosition,
                        size: self.frame.size)
                    
                    self.addSubview(viewTick)
                    arrTicks.append(viewTick)
                }
                else {
                    viewTick                            = UIView(frame: CGRectMake(0, 0, 6, 1))
                    viewTick.layer.shouldRasterize      = true
                    viewTick.backgroundColor            = UIColor.dialsDarkGrey()
                    viewTick.transform                  = CGAffineTransformMakeRotation(CGFloat(i) * CGFloat(M_PI) / 180.0)
                    
                    viewTick.center                     = DSUtils.convertDegreesToPosition(
                        Double(i),
                        radiusOffset: Constants.Radius.ClockPosition,
                        size: self.frame.size)
                    
                    self.addSubview(viewTick)
                    arrTicks.append(viewTick)
            }
        }
    }
    
    private func addCreateNewEventButton() {
        let fSize                           = CGFloat(Constants.Sizes.AddNewEvent)
        let fOffset                         = CGFloat(Constants.Offset.AddNewEvent)
        
        if let btnAddNew = self.btnAddNew {
            btnAddNew.frame                 = CGRectMake(0.0, 0.0, fSize, fSize)
            btnAddNew.center                = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + fOffset)
            self.addSubview(btnAddNew)
        }
        else {
            let btnAddNew                   = UIButton(type: .Custom)
            btnAddNew.frame                 = CGRectMake(0.0, 0.0, fSize, fSize)
            btnAddNew.backgroundColor       = UIColor.blackColor()
            btnAddNew.center                = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + fOffset)
            btnAddNew.layer.cornerRadius    = btnAddNew.frame.size.width / 2
            btnAddNew.layer.masksToBounds   = true
            btnAddNew.addTarget(self, action: "btnAddNewEvent_Action:", forControlEvents: .TouchUpInside)
            btnAddNew.setTitle("+", forState: .Normal)
            btnAddNew.setTitleColor(UIColor.dialsWhite(), forState: .Normal)
            btnAddNew.titleLabel?.font      = UIFont.proximaBoldOfSize(40.0)
            btnAddNew.titleLabel?.textAlignment     = .Center
            btnAddNew.contentHorizontalAlignment    = .Center
            
            btnAddNew.titleEdgeInsets       = UIEdgeInsetsMake(3, 0, 0, 0);
            
            self.addSubview(btnAddNew)
            
            self.btnAddNew                  = btnAddNew
        }
    }
    
    private func addTimerHand() {
        timerHandView                       = DSTimerHandView(frame: CGRectMake(0.0, 0.0, 315.0, 315.0))
        timerHandView!.center               = DSUtils.getCenterOfView(self)
        timerHandView!.initTimerHandView(self)
        self.addSubview(timerHandView!)
    }
    
    // MARK: - Custom Methods
    
    private func bringEventViewsToFront() {
        for dsDialEventView in arrDialEventViews {
            self.bringSubviewToFront(dsDialEventView)
        }
    }
    
    private func showEventDuration(event: Event) {
        showEventDurationLayer(event)
        
        //>     Show event end
        if let selectedDialEventEndView = DSDialEventView.loadFromNibNamed("DSDialEventView") as? DSDialEventView {
            selectedDialEventEndView.curEvent           = event
            selectedDialEventEndView.frame              = CGRectMake(0.0, 0.0, CGFloat(Constants.Sizes.EventEndView), CGFloat(Constants.Sizes.EventEndView))
            selectedDialEventEndView.delegate           = self
            selectedDialEventEndView.isEventEndView     = true
            selectedDialEventEndView.setupView(self)
            
            self.addSubview(selectedDialEventEndView)
            
            self.dialEventViewEnd                       = selectedDialEventEndView
        }
    }
    
    private func showEventDurationLayer(event: Event) {
        let radius                          = self.frame.size.width / 2 - CGFloat(Constants.Offset.AMPMStroke) - 3
        
        eventDurationLayer.path             = UIBezierPath(
            arcCenter: DSUtils.getCenterOfView(self),
            radius: radius,
            startAngle: CGFloat(DSUtils.convertTimeToRadians(event.e_startDate)),
            endAngle: CGFloat(DSUtils.convertTimeToRadians(event.e_endDate)),
            clockwise: true).CGPath
        
        eventDurationLayer.strokeColor      = UIColor.redColor().CGColor
        eventDurationLayer.fillColor        = UIColor.clearColor().CGColor
        eventDurationLayer.lineWidth        = 8.0
        eventDurationLayer.lineCap          = kCALineCapButt
        eventDurationLayer.lineJoin         = kCALineJoinMiter
        
        self.layer.addSublayer(eventDurationLayer)
    }
    
    private func updateEventDurationLayer(event: Event) {
        let radius                          = self.frame.size.width / 2 - CGFloat(Constants.Offset.AMPMStroke) - 3
        
        eventDurationLayer.path             = UIBezierPath(
            arcCenter: DSUtils.getCenterOfView(self),
            radius: radius,
            startAngle: CGFloat(DSUtils.convertTimeToRadians(newStartDate)),
            endAngle: CGFloat(DSUtils.convertTimeToRadians(newEndDate)),
            clockwise: true).CGPath
        
        eventDurationLayer.didChangeValueForKey("path")
    }
    
    private func removeEventDuration() {
        eventDurationLayer.removeFromSuperlayer()
        
        if let selectedDialEventEndView = self.dialEventViewEnd {
            selectedDialEventEndView.removeFromSuperview()
            
            self.dialEventViewEnd           = nil
        }
    }
    
    func updateEventStartEndInterval() {
        let degreesStart                    = DSUtils.convertPositionToDegrees(dialEventViewStart!.center, size: self.frame.size)
        let degreesEnd                      = DSUtils.convertPositionToDegrees(dialEventViewEnd!.center, size: self.frame.size)
        
        let differenceDegrees               = degreesEnd - degreesStart
        
        let interval                        = Int(ceil(differenceDegrees / 30 * 3600))
        var intervalTemp                    = interval
        
        var multiplier                      = 0
        
        if intervalTemp > 3600 {
            multiplier                      = Int(floor(Double(intervalTemp) / 3600))
        }
        
        multiplier                          = multiplier * 3600
        
        if intervalTemp > (multiplier + 800) && intervalTemp < (multiplier + 1000) {
            intervalTemp                    = multiplier + 900
        }
        else
            if intervalTemp > (multiplier + 1500) && intervalTemp < (multiplier + 2100) {
                intervalTemp                    = multiplier + 1800
            }
            else
                if intervalTemp > (multiplier + 2400) && intervalTemp < (multiplier + 3000) {
                    intervalTemp                    = multiplier + 2700
                }
                else
                    if intervalTemp > (multiplier + 3300) {
                        intervalTemp                    = multiplier + 3600
                    }
                    else {
                        intervalTemp                    = multiplier
        }
        
        intervalStartEnd                    = Double(intervalTemp)
    }
    
    func update(pointStart: CGPoint, pointEnd: CGPoint) {
        newStartDate                        = DSUtils.convertPositionToTime(pointStart, size: self.frame.size)
        
        if dialEventViewStart!.curEvent!.e_startDate.hour() >= 12 {
            newStartDate                    = newStartDate.dateByAddingHours(12)
        }
        
        var newDate                         = newStartDate
        newDate                             = newDate.dateByAddingSeconds(Int(intervalStartEnd))

        newEndDate                          = newDate
    }
    
    func didChangeEventTime(event: Event) -> Bool {
        if let dialEventViewStart = dialEventViewStart {
            if let event = dialEventViewStart.curEvent {
                if event.e_startDate.isEqualToDate(newStartDate) &&
                    event.e_endDate.isEqualToDate(newEndDate) {
                        return false
                }
            }
        }
        
        return true
    }
    
    func resetDialEventViewStartPosition(event: Event) {
        if let dialEventViewStart = dialEventViewStart {
            dialEventViewStart.center       = DSUtils.convertTimeToPosition(
                event.e_startDate,
                radiusOffset: Constants.Radius.EventPosition,
                size: self.frame.size)
            
            let angle                                       = DSUtils.convertPositionToAngle(dialEventViewStart.center, size:self.frame.size)
            dialEventViewStart.imgViewIcon?.transform       = CGAffineTransformMakeRotation(angle)
        }
    }
    
    // MARK: - Event Selection Methods
    
    func selectEvent(dsDialEventView: DSDialEventView) {
        self.dialEventViewStart             = dsDialEventView
        
        if let event = dsDialEventView.curEvent {
            newStartDate                    = event.e_startDate
            newEndDate                      = event.e_endDate
            intervalStartEnd                = newEndDate.timeIntervalSinceDate(newStartDate)
        
            self.showEventDuration(dsDialEventView.curEvent!)
        }
        
        self.bringSubviewToFront(self.dialEventViewStart!)
        self.bringSubviewToFront(self.dialEventViewEnd!)
        
        self.dialEventViewStart?.enablePanning(self.dialEventViewEnd!)
        
        self.setupTapToDeselectGesture()
    }
    
    func deselectEvent() {
        self.removeEventDuration()
        
        self.removeTapToDeselectGesture()
        
        self.dialEventViewStart?.disablePanning()
        
        self.dialEventViewStart?.setupTapGesture()
        
        self.dialEventViewStart      = nil
    }
    
    // MARK: - Gesture Methods
    
    private func setupTapToDeselectGesture() {
        self.tapToDeselectGesture                           = UITapGestureRecognizer(target: self, action: "handleTapToDeselectGesture:")
        
        self.addGestureRecognizer(self.tapToDeselectGesture)
    }
    
    private func removeTapToDeselectGesture() {
        self.removeGestureRecognizer(self.tapToDeselectGesture)
    }
    
    // MARK: - Action Methods
    
    func btnAddNewEvent_Action(button: UIButton) {
        
    }
    
    func handleTapToDeselectGesture(gesture: UITapGestureRecognizer) {
        if let dialEventViewStart = dialEventViewStart {
            if let event = dialEventViewStart.curEvent {
                if didChangeEventTime(event) {
                    self.delegate?.didChangeTimeForEvent(event)
                }
                else {
                    self.deselectEvent()
                }
            }
        }
    }
    
    // MARK: - DSDialEventViewDelegate Methods
    
    func didTapView(dsDialEventView: DSDialEventView) {
        if self.dialEventViewStart == dsDialEventView {
            self.deselectEvent()
        }
        else {
            self.selectEvent(dsDialEventView)
        }
    }
    
    func didPanView(dsDialEventView: DSDialEventView) {
        if dsDialEventView == dialEventViewStart {
            let newDateForStartView             = DSUtils.convertPositionToTime(dsDialEventView.center, size:self.frame.size)
            let newDateForEndView               = newDateForStartView.dateByAddingTimeInterval(intervalStartEnd)
            let newCenterForEndView             = DSUtils.convertTimeToPosition(newDateForEndView, radiusOffset:Constants.Radius.EventPosition, size:self.frame.size)
            self.dialEventViewEnd?.center       = newCenterForEndView
            
            newStartDate                        = newDateForStartView
            newEndDate                          = newDateForEndView
            
            if let dsDialEventViewEnd = dialEventViewEnd {
                let angle                                       = DSUtils.convertPositionToAngle(dsDialEventViewEnd.center, size:self.frame.size)
                dsDialEventViewEnd.imgViewIcon?.transform       = CGAffineTransformMakeRotation(angle)
            }
            
            updateEventDurationLayer(dsDialEventView.curEvent!)
        }
        else
            if dsDialEventView == dialEventViewEnd {
                newEndDate          = DSUtils.convertPositionToTime(dsDialEventView.center, size: self.frame.size)
                self.updateEventStartEndInterval()
                
                updateEventDurationLayer(dsDialEventView.curEvent!)
                
                let pathRef                     = eventDurationLayer.path
                let pathRec                     = CGPathGetBoundingBox(pathRef)
                
                if CGRectIntersectsRect(dialEventViewStart!.frame, dialEventViewEnd!.frame) {
                    
                }
        }
        
        self.update(dialEventViewStart!.center, pointEnd:dialEventViewEnd!.center)
        
    }
    
    // MARK: - Drawing Methods
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func drawRect(rect: CGRect) {
        
    }*/


}
