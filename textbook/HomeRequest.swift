//
//  HomeRequest.swift
//  textbook
//
//  Created by John Wong on 4/21/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class HomeRequest: Request {
    override func urlPath() -> String {
        return AppConfiguration.URLs.index
    }
}
