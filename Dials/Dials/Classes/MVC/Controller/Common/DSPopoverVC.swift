//
//  DSPopoverVC.swift
//  Dials
//
//  Created by Abel Anca on 8/14/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

protocol DSPopoverVCDelegate {
    func didSelectDataInPopover(obj: AnyObject, sender: AnyObject?)
}


class DSPopoverVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet var tblData: UITableView!
    
    var delegate: DSPopoverVCDelegate? 
    
    var uiLastIndexCount: Int?
    var arrData: [[String : AnyObject]]?
    var arrDataSpecial: [[String : AnyObject]]?
    var arrLetters      = [String]()
    
    var objParent: AnyObject?
    var objSelected: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if arrData == nil {
            
            if let strJSONPath = NSBundle.mainBundle().pathForResource("Countries", ofType: "json") {
                if let jsonData = NSData(contentsOfFile: strJSONPath) {
                    
                    do {
                        // Try parsing some valid JSON
                        let parsed = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
                        
                        //print(parsed, appendNewline: true)
                        
                        if let arrParsed = parsed as? [[String: AnyObject]] {

                            arrData         = arrParsed
                        }
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                }
            }
        }
        
        for dictObject in arrData! {
            if let strName = dictObject["name"] as? String {
                let index: String.Index     = advance(strName.startIndex, 1)
                let strLetter = strName.substringToIndex(index)
                
                if (arrLetters.contains(strLetter) == false) {
                    arrLetters.append(strLetter)
                }
            }
        }
        
        if tblData.respondsToSelector("setSectionIndexColor:") == true {
            tblData.sectionIndexColor                       = UIColor.color(196, green: 196, blue: 196, alpha: 1)
            tblData.sectionIndexTrackingBackgroundColor     = UIColor.color(26, green: 26, blue: 26, alpha: 1)
            tblData.sectionIndexBackgroundColor             = UIColor.color(26, green: 26, blue: 26, alpha: 1)
        }
        
        tblData.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Methods
    
    func indexForFirstChar(character: String, array: [[String : AnyObject]]?) -> Int {
        var count = 0
        
        for dictObject in arrData! {
            if let strName = dictObject["name"] as? String {
                if strName.hasPrefix(character) {
                    uiLastIndexCount = count
                    
                    return count
                }
            }
            
            count++
        }
        
        return uiLastIndexCount!
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return arrLetters
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "English";
        }
        else {
            return "Others";
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        let newRow = indexForFirstChar(title, array: arrData)
        
        let newIndexPath = NSIndexPath(forRow: newRow, inSection: 1)
        tableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
        return index + 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrDataSpecial!.count
        }
        else {
            return arrData!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID          = "DSPopoverCell_ID"
        let cell            = tableView.dequeueReusableCellWithIdentifier(cellID)
        let lblData         = cell?.contentView.viewWithTag(100) as! UILabel
        
        var obj             = self.arrData![indexPath.row]
        
        if indexPath.section == 0 {
            obj             = self.arrDataSpecial![indexPath.row]
        }
        
        if let strName = obj["name"] {
            if let strDial = obj["Dial"] {
                lblData.text    = "\(strName) +\(strDial)"
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var obj             = self.arrData![indexPath.row]
        
        if indexPath.section == 0 {
            obj             = self.arrDataSpecial![indexPath.row]
        }
        
        self.delegate?.didSelectDataInPopover(obj, sender: objParent)
    }
  
}
