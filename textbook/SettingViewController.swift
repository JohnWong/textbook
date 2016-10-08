//
//  SettingViewController.swift
//  textbook
//
//  Created by John Wong on 4/24/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    struct StoryBoard {
        struct Cells {
            static let menuCell = "menuCell"
        }
    }
    
    static let IconAbout = "IconAbout"
    static let IconHelp = "IconHelp"
    static let IconPrivacy = "IconPrivacy"
    static let IconClear = "IconClear"
    let icons = [IconAbout, IconHelp, IconPrivacy, IconClear]
    let titles = ["关于", "帮助", "隐私政策", "清空缓存"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.icons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.Cells.menuCell, for: indexPath) 
        cell.selectedBackgroundView = UIView()
        cell.imageView?.image = UIImage(named: icons[(indexPath as NSIndexPath).row])
        cell.textLabel?.text = titles[(indexPath as NSIndexPath).row]
        cell.textLabel?.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sideMenuViewController.hideViewController()
        let controller: NavigationViewController = self.sideMenuViewController.contentViewController as! NavigationViewController
        switch icons[(indexPath as NSIndexPath).row] {
        case SettingViewController.IconClear:
            clearCache()
            return
        case SettingViewController.IconAbout:
            controller.selectedUrl = 0
        case SettingViewController.IconHelp:
            controller.selectedUrl = 1
        case SettingViewController.IconPrivacy:
            controller.selectedUrl = 2
        default:
            break
        }
        controller.performSegue(withIdentifier: "pushWebView", sender: self)
    }
    
    // MARK: - Action
    func clearCache() {
        RequestCache.clearCachedResponse()
        SDImageCache.shared().clearDisk()
        self.sideMenuViewController.hideViewController()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: AppConfiguration.Notifications.CacheClear), object: nil))
    }

}
