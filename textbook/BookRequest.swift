//
//  BookRequest.swift
//  textbook
//
//  Created by John Wong on 4/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class BookRequest: Request {
    
    var bookPath: String = ""
    
    override func urlPath() -> String {
        return AppConfiguration.URLs.host + "/" + bookPath
    }
}