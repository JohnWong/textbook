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
    
    class func setObject(_ value: AnyObject?, forKey key: String) {
        if let value: AnyObject = value {
            let userDefaults = Foundation.UserDefaults.standard
            let archivedObject = NSKeyedArchiver.archivedData(withRootObject: value)
            userDefaults.set(archivedObject, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    class func objectForKey(_ key: String) -> AnyObject? {
        let userDefaults = Foundation.UserDefaults.standard
        let object: AnyObject? =  userDefaults.object(forKey: key) as AnyObject?
        if let object = object as? Data {
            let originObj: AnyObject? = NSKeyedUnarchiver.unarchiveObject(with: object) as AnyObject?
            return originObj
        }
        return nil
    }
}
