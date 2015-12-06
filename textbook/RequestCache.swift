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
        var cacheDirectory = paths[0] 
        cacheDirectory = (cacheDirectory as NSString).stringByAppendingPathComponent("RequestCache")
        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(cacheDirectory) {
            var error: NSError?
            do {
                try fileManager.createDirectoryAtPath(cacheDirectory, withIntermediateDirectories: true, attributes: nil)
                if let error = error {
                    print("write failure: \(error.localizedDescription)")
                }
            } catch var error1 as NSError {
                error = error1
            } catch {
                fatalError()
            }
        }
        return cacheDirectory
    }()
    
    class func cacheResponse(response :String, forPath path: String) {
        let pathHash = cachedFileNameForKey(path)
        let filePath = (self.cachePath as NSString).stringByAppendingPathComponent(pathHash);
        var writeError: NSError?
        let written: Bool
        do {
            try response.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            written = true
        } catch let error as NSError {
            writeError = error
            written = false
        }
        if !written {
            if let error = writeError {
                print("write failure: \(error.localizedDescription)")
            }
        }
    }
    
    class func getCachedResponseForPath(path: String) -> String? {
        let pathHash = cachedFileNameForKey(path)
        let filePath = (self.cachePath as NSString).stringByAppendingPathComponent(pathHash);
        var readError: NSError?
        var str: NSString?
        do {
            str = try NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            readError = error
            str = nil
        }
        if let error = readError {
            print("read failure: \(error.localizedDescription)")
        }
        return str as? String
    }
    
    class func clearCachedResponse() {
        let fileManager = NSFileManager.defaultManager()
        let cacheList = fileManager.subpathsAtPath(cachePath)
        if let cacheList = cacheList {
            for cache in cacheList {
                if let cache = cache as? String {
                    var error: NSError?
                    do {
                        try fileManager.removeItemAtPath((self.cachePath as NSString).stringByAppendingPathComponent(cache))
                    } catch let error1 as NSError {
                        error = error1
                    }
                    if let error = error {
                        print("clear failure: \(error.localizedDescription) \(cache)")
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
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return hash as String
    }
}
