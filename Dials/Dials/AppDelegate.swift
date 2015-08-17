//
//  AppDelegate.swift
//  Dials
//
//  Created by Beny Boariu on 08/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import DialsSyncManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var storyboardLogin: UIStoryboard = {
        var storyboard      = UIStoryboard(name: "Login", bundle: nil)
        
        return storyboard
        }()
    
    //>     Creating an Instance of the Alamofire Manager
    var manager = Alamofire.Manager.sharedInstance
    
    //>     Creating an Instance of the DialsSyncManager
    let dsSyncManager               = DSSyncManager()
    
    var realm: Realm!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupAlamofireManager()
        
        self.realm      = try! Realm()

        // Easily see where the realm database is located so we can open it with the Realm Browser
        print(self.realm.path, appendNewline: true)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Custom Methods
    
    func setupAlamofireManager() {
        var defaultHeaders                  = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Content-Type"]      = "application/json"
        defaultHeaders["Accept"]            = "application/vnd.dials.v1+json"
        
        let configuration       = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        self.manager            = Alamofire.Manager(configuration: configuration)
    }

}

// MARK: - Convenience Constructors

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

