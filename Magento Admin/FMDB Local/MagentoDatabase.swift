//
//  MagentoDatabase.swift
//  Magento Admin
//
//  Created by Lokesh Gupta on 28/09/17.
//  Copyright © 2017 Lokesh Gupta. All rights reserved.
//

import UIKit

class MagentoDatabase: NSObject {

    static let sharedInstance = MagentoDatabase()
    var databasePath = String()
    var MagentoDB : FMDatabase!
    
    
    func createDB() {
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        self.databasePath = dirPaths[0].appendingPathComponent("MagentoDB.db").path
        
        if !filemgr.fileExists(atPath: self.databasePath as String) {
            
            self.MagentoDB = FMDatabase(path: self.databasePath as String)
            
            if (self.MagentoDB) != nil {
            }
            else{
                print("Error: \(self.MagentoDB.lastErrorMessage())")
            }
            
        }
        else {
            self.MagentoDB = FMDatabase(path: self.databasePath as String)

            print("Else")
        }

    }
}
