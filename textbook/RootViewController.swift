//
//  RootViewController.swift
//  textbook
//
//  Created by John Wong on 4/23/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu {

    override func awakeFromNib() {
        var storyboard: UIStoryboard = self.storyboard!
        
        self.contentViewController = storyboard.instantiateViewControllerWithIdentifier("contentViewController") as! UIViewController
        self.leftMenuViewController = storyboard.instantiateViewControllerWithIdentifier("settingViewController") as! UIViewController
    }
}
