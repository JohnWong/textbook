//
//  XMLRequest.swift
//  textbook
//
//  Created by John Wong on 4/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class IndexRequest: Request {
    
    override func urlPath() -> String {
        return AppConfiguration.Indexes.indexOneFirst
    }
    
    override func parse(body: String, withCompletion completion: (dict: NSDictionary?, error: NSError?) -> Void) {
        var error: NSError?
        var jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, options: NSJSONReadingOptions(), error: &error)
        if let dict = jsonObject as? NSDictionary {
            completion(dict: dict, error: nil)
        } else {
            completion(dict: nil, error: NSError(domain: "JSON解析出错", code: 1, userInfo: nil))
        }
    }
}