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
        static let host = "https://dn-johnstatic.qbox.me/textbook/"
//        static let host = "http://localhost:7000/"
        static let index = host + "index.json"
    }
    
    static let Debug = NSBundle.mainBundle().objectForInfoDictionaryKey("Debug") as? String == "YES"
    
    struct Notifications {
        static let BookUpdate = "BookUpdate"
        static let CacheClear = "CacheClear"
    }
    
    class func showError(message: String, subtitle: String?) {
        var rootViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        TSMessage.showNotificationInViewController(
            TSMessage.defaultViewController(),
            title: message,
            subtitle: subtitle,
            image: nil,
            type: TSMessageNotificationType.Error,
            duration: 1,
            callback: nil,
            buttonTitle: nil,
            buttonCallback: nil,
            atPosition: TSMessageNotificationPosition.NavBarOverlay,
            canBeDismissedByUser: true)
    }
    
    class func showSuccess(message: String, subtitle: String?) {
        var rootViewController:UIViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        TSMessage.showNotificationInViewController(
            TSMessage.defaultViewController(),
            title: message,
            subtitle: subtitle,
            image: nil,
            type: TSMessageNotificationType.Success,
            duration: 1,
            callback: nil,
            buttonTitle: nil,
            buttonCallback: nil,
            atPosition: TSMessageNotificationPosition.NavBarOverlay,
            canBeDismissedByUser: true)
    }
    
}