//
//  Utility.swift
//  textbook
//
//  Created by John Wong on 4/25/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class Utility {
    
    class func cleanString(str: String) -> String {
        return str
            .stringByReplacingOccurrencesOfString("<b>", withString: "")
            .stringByReplacingOccurrencesOfString("</b>", withString: "")
            .stringByReplacingOccurrencesOfString("<strong>", withString: "")
            .stringByReplacingOccurrencesOfString("</strong>", withString: "")
            .stringByReplacingOccurrencesOfString("</srong>", withString: "")
            .stringByReplacingOccurrencesOfString("<p>", withString: "")
            .stringByReplacingOccurrencesOfString("</p>", withString: "")
    }
   
    class func appVersion() -> String {
        let infoDictionary: NSDictionary = NSBundle.mainBundle().infoDictionary!
        return infoDictionary.objectForKey("CFBundleShortVersionString") as! String
    }
}
