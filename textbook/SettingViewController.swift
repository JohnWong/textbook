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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.icons.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.Cells.menuCell, forIndexPath: indexPath) as! UITableViewCell
        cell.selectedBackgroundView = UIView()
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.sideMenuViewController.hideMenuViewController()
        let controller: NavigationViewController = self.sideMenuViewController.contentViewController as! NavigationViewController
        switch icons[indexPath.row] {
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
        controller.performSegueWithIdentifier("pushWebView", sender: self)
    }
    
    // MARK: - Action
    func clearCache() {
        RequestCache.clearCachedResponse()
        SDImageCache.sharedImageCache().clearDisk()
        self.sideMenuViewController.hideMenuViewController()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: AppConfiguration.Notifications.CacheClear, object: nil))
    }

}
