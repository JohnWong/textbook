//
//  AppConfiguration.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class AppConfiguration {
    struct URLs {
        static let host = "http://localhost:7000"
        static let index = host + "/index.json"
        static let demo = host + "/index1s.json"
    }
    
    struct Notifications {
        static let BookUpdate = "BookUpdate"
    }
    
}