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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.cacheCleared), name: NSNotification.Name(rawValue: AppConfiguration.Notifications.CacheClear), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func awakeFromNib() {
        let storyboard: UIStoryboard = self.storyboard!
        
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
        self.contentViewShadowColor = UIColor.black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0);
        self.contentViewShadowOpacity = 0.6;
        self.contentViewShadowRadius = 12;
        self.contentViewShadowEnabled = true;
    
        
        self.contentViewController = storyboard.instantiateViewController(withIdentifier: StoryBoard.ControllerIdentifiers.contentViewController) 
        self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: StoryBoard.ControllerIdentifiers.settingViewController) 
        
        self.backgroundImage = UIImage(named: "Stars");
    }
    
    func cacheCleared() {
        AppConfiguration.showSuccess("缓存已清空", subtitle: nil)
    }
}
