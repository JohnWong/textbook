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
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        var cacheDirectory = paths[0] 
        cacheDirectory = (cacheDirectory as NSString).appendingPathComponent("RequestCache")
        var fileManager = FileManager.default
        if !fileManager.fileExists(atPath: cacheDirectory) {
            var error: NSError?
            do {
                try fileManager.createDirectory(atPath: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
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
    
    class func cacheResponse(_ response :String, forPath path: String) {
        let pathHash = cachedFileNameForKey(path)
        let filePath = (self.cachePath as NSString).appendingPathComponent(pathHash);
        var writeError: NSError?
        let written: Bool
        do {
            try response.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
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
    
    class func getCachedResponseForPath(_ path: String) -> String? {
        let pathHash = cachedFileNameForKey(path)
        let filePath = (self.cachePath as NSString).appendingPathComponent(pathHash);
        var readError: NSError?
        var str: NSString?
        do {
            str = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
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
        let fileManager = FileManager.default
        let cacheList = fileManager.subpaths(atPath: cachePath)
        if let cacheList = cacheList {
            for cache in cacheList {
                if let cache = cache as? String {
                    var error: NSError?
                    do {
                        try fileManager.removeItem(atPath: (self.cachePath as NSString).appendingPathComponent(cache))
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
    
    class func cachedFileNameForKey(_ key: String) -> String {
        let str = key.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(key.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return hash as String
    }
}
