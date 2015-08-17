//
//  DSSyncManager.swift
//  DialsSyncManager
//
//  Created by Beny Boariu on 17/08/15.
//  Copyright © 2015 DayDials. All rights reserved.
//

import Foundation

public class DSSyncManager {
    public init() {
        
    }
    
    public func canRunVersion(strVersion: String) -> Bool {
        if strVersion == "1" {
            return true
        }
        else {
            return false
        }
    }
    
    public func canRunVersion1(strVersion: String) -> Bool {
        if strVersion == "1" {
            return true
        }
        else {
            return false
        }
    }
}