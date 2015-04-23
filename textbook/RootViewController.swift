//
//  RootViewController.swift
//  textbook
//
//  Created by John Wong on 4/23/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu {
    
    struct StoryBoard {
        struct ControllerIdentifiers {
            static let contentViewController = "contentViewController"
            static let settingViewController = "settingViewController"
        }
    }

    override func awakeFromNib() {
        var storyboard: UIStoryboard = self.storyboard!
        
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.6;
        self.contentViewShadowRadius = 12;
        self.contentViewShadowEnabled = true;
    
        
        self.contentViewController = storyboard.instantiateViewControllerWithIdentifier(StoryBoard.ControllerIdentifiers.contentViewController) as! UIViewController
        self.leftMenuViewController = storyboard.instantiateViewControllerWithIdentifier(StoryBoard.ControllerIdentifiers.settingViewController) as! UIViewController
        
        self.backgroundImage = UIImage(named: "Stars");
    }
}
