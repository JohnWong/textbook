//
//  Utility.swift
//  textbook
//
//  Created by John Wong on 4/25/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class Utility {
    
    class func cleanString(_ str: String) -> String {
        return str
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "<strong>", with: "")
            .replacingOccurrences(of: "</strong>", with: "")
            .replacingOccurrences(of: "</srong>", with: "")
            .replacingOccurrences(of: "<p>", with: "")
            .replacingOccurrences(of: "</p>", with: "")
    }
   
    class func appVersion() -> String {
        let infoDictionary: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        return infoDictionary.object(forKey: "CFBundleShortVersionString") as! String
    }
}
