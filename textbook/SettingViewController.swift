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
    
    static let IconClear = "IconClear"
    static let IconProfile = "IconProfile"
    let icons = [IconClear, IconProfile]
    let titles = ["清空缓存", "Profile"]
    
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
        return icons.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.Cells.menuCell, forIndexPath: indexPath) as! UITableViewCell
        cell.selectedBackgroundView = UIView()
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch icons[indexPath.row] {
        case SettingViewController.IconClear:
            clearCache()
        case SettingViewController.IconProfile:
            break
        default:
            break
        }
    }
    
    // MARK: - Action
    func clearCache() {
        RequestCache.clearCachedResponse()
        self.sideMenuViewController.hideMenuViewController()
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: AppConfiguration.Notifications.CacheClear, object: nil))
    }

}
