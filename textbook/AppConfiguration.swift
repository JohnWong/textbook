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
    
    static let Debug = Bundle.main.object(forInfoDictionaryKey: "Debug") as? String == "YES"
    
    struct Notifications {
        static let BookUpdate = "BookUpdate"
        static let CacheClear = "CacheClear"
    }
    
    class func showError(_ message: String, subtitle: String?) {
        TSMessage.showNotification(
            in: TSMessage.defaultViewController(),
            title: message,
            subtitle: subtitle,
            image: nil,
            type: TSMessageNotificationType.error,
            duration: 1,
            callback: nil,
            buttonTitle: nil,
            buttonCallback: nil,
            at: TSMessageNotificationPosition.navBarOverlay,
            canBeDismissedByUser: true)
    }
    
    class func showSuccess(_ message: String, subtitle: String?) {
        TSMessage.showNotification(
            in: TSMessage.defaultViewController(),
            title: message,
            subtitle: subtitle,
            image: nil,
            type: TSMessageNotificationType.success,
            duration: 1,
            callback: nil,
            buttonTitle: nil,
            buttonCallback: nil,
            at: TSMessageNotificationPosition.navBarOverlay,
            canBeDismissedByUser: true)
    }
    
}
