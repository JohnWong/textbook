//
//  UserDefaults.swift
//  textbook
//
//  Created by John Wong on 4/22/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class UserDefaults {
    
    struct Keys {
        static let selectedBook = "SelectedBook"
    }
    
    class func setObject(value: AnyObject?, forKey key: String) {
        if let value: AnyObject = value {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(value)
            userDefaults.setObject(archivedObject, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    class func objectForKey(key: String) -> AnyObject? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let object: AnyObject? =  userDefaults.objectForKey(key)
        if let object = object as? NSData {
            let originObj: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(object)
            return originObj
        }
        return nil
    }
}
