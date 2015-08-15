//
//  DSIntroPageVC.swift
//  Dials
//
//  Created by Abel Anca on 8/10/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit

class DSIntroPageVC: UIViewController {

    var arrData: [[String: AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if arrData == nil {
            
            if let strJSONPath = NSBundle.mainBundle().pathForResource("Countries", ofType: "json") {
                if let jsonData = NSData(contentsOfFile: strJSONPath) {
                    
                    do {
                        // Try parsing some valid JSON
                        let parsed = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
   
                        //print(parsed, appendNewline: true)
                        
                        if let arrParsed = parsed as? [[String: AnyObject]] {
                            print("hei", appendNewline: true)
                        
                            arrData         = arrParsed
                            
                            for dictObject in arrParsed {
                                if let strName = dictObject["name"] as? String {
                                    print("Name: \(strName)", appendNewline: true)
                                }
                            }
                        }
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                }
            }
        }

        print(arrData, appendNewline: true)
    }

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
