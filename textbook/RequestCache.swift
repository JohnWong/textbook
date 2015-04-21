//
//  RequestCache.swift
//  textbook
//
//  Created by John Wong on 4/21/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class RequestCache: NSObject {
    
    static var cachePath: String = {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        var cacheDirectory = paths[0] as! String
        cacheDirectory = cacheDirectory.stringByAppendingPathComponent("RequestCache")
        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(cacheDirectory) {
            var error: NSError?
            if fileManager.createDirectoryAtPath(cacheDirectory, withIntermediateDirectories: true, attributes: nil, error: &error) {
                if let error = error {
                    println("write failure: \(error.localizedDescription)")
                }
            }
        }
        return cacheDirectory
    }()
    
    class func cacheResponse(response :String, forPath path: String) {
        var pathHash = cachedFileNameForKey(path)
        var filePath = self.cachePath.stringByAppendingPathComponent(pathHash);
        var writeError: NSError?
        let written = response.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding, error: &writeError)
        if !written {
            if let error = writeError {
                println("write failure: \(error.localizedDescription)")
            }
        }
    }
    
    class func getCachedResponseForPath(path: String) -> String? {
        var pathHash = cachedFileNameForKey(path)
        var filePath = self.cachePath.stringByAppendingPathComponent(pathHash);
        var readError: NSError?
        var str = NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: &readError)
        if let error = readError {
            println("read failure: \(error.localizedDescription)")
        }
        return str as? String
    }
    
    class func clearCachedResponse() {
        var fileManager = NSFileManager.defaultManager()
        var cacheList = fileManager.subpathsAtPath(cachePath)
        if let cacheList = cacheList {
            for cache in cacheList {
                if let cache = cache as? String {
                    var error: NSError?
                    fileManager.removeItemAtPath(self.cachePath.stringByAppendingPathComponent(cache), error: &error)
                    if let error = error {
                        println("clear failure: \(error.localizedDescription) \(cache)")
                    }
                }
            }
        }
    }
    
    class func cachedFileNameForKey(key: String) -> String {
        let str = key.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return hash as String
    }
}
