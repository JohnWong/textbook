//
//  JWRequest.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class Request {
    
    var request: STHTTPRequest?
    
    func urlPath() -> String {
        return ""
    }
    
    func encoding() -> String {
        return "UTF-8"
    }
    
    func loadWithCompletion(_ completion:@escaping (_ dict: NSDictionary?, _ error: NSError?) -> Void) {
        loadWithCompletion(completion, progress:nil)
    }
    
    func loadWithCompletion(_ completion:@escaping (_ dict: NSDictionary?, _ error: NSError?) -> Void, progress:((_ percent: Float) -> Void)?) {
        if urlPath().lengthOfBytes(using: String.Encoding.utf8) == 0 {
            completion(nil, NSError(domain: "没有URL", code: 1, userInfo: nil));
            return;
        }
        let str = RequestCache.getCachedResponseForPath(urlPath())
        if let str = str {
            parse(str, withCompletion: completion)
        } else {
            NSLog("JWRequest: load \(urlPath())")
            request?.cancel()
            request = STHTTPRequest(urlString: urlPath())
            request?.setValue(encoding(), forKey: "responseStringEncodingName")
            request?.completionBlock = {
                [unowned self](headers: Dictionary<AnyHashable, Any>?, body: String?) in
//                NSLog("JWRequest: completion \(headers as NSDictionary) \(body)")
                RequestCache.cacheResponse(body!, forPath: self.urlPath())
                self.parse(body!, withCompletion: completion)
            }
            request?.errorBlock = {
                (error) -> Void in
                let err = error as! NSError
                if err.code == 1 {
                    return
                }
                completion(nil, error as NSError?)
            }
            request?.downloadProgressBlock = {
                (data, totalBytesReceived, totalBytesExpectedToReceive) -> Void in
                if let progress = progress {
                    var percent: Float = 100 * Float(totalBytesReceived)
                    percent = percent / Float(totalBytesExpectedToReceive)
                    progress(percent);
                }
            }
            request?.startAsynchronous()
        }
    }
    
    func parse(_ body: String, withCompletion completion:(_ dict: NSDictionary?, _ error: NSError?) -> Void) {
        var jsonObject: Any?
        do {
            jsonObject = try JSONSerialization.jsonObject(with: body.data(using: String.Encoding.utf8, allowLossyConversion: false)!, options: JSONSerialization.ReadingOptions())
        } catch let error1 as NSError {
            jsonObject = nil
        }
        if let dict = jsonObject as? NSDictionary {
            completion(dict, nil)
        } else {
            completion(nil, NSError(domain: "JSON解析出错", code: 1, userInfo: nil))
        }
    }
}
