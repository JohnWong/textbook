//
//  MasterViewController.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var bookRequest = BookRequest()
    var bookItem = BookItem()
    
    @IBAction func clearCache(sender: UIButton) {
        RequestCache.clearCachedResponse()
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    
    struct StoryBoard {
         struct Cells {
            static let cell = "Cell"
            static let cellBold = "CellBold"
        }
        
         struct Segues {
            static let showDetail = "showDetail"
            static let pickBook = "pickBook"
            static let showWebView = "showWebView"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reload"), name: AppConfiguration.Notifications.BookUpdate, object: nil)
        self.reload()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.cancelSGProgress()
    }
    
    func reload() {
        let item: AnyObject? = UserDefaults.objectForKey(UserDefaults.Keys.selectedBook)
        if let collectItem = item as? CollectItem {
            bookRequest.bookPath = collectItem.link
            bookRequest.loadWithCompletion(
                {
                    [unowned self](dict, error) -> Void in
                    if let dict = dict {
                        self.bookItem = BookItem(dict: dict)
                        self.title = self.bookItem.name
                        self.tableView.reloadData()
                    } else {
                        AppConfiguration.showError("数据加载失败", subtitle: error?.localizedDescription)
                    }
                }, progress: {
                    [unowned self](percent) -> Void in
                    self.navigationController?.setSGProgressPercentage(percent, andTitle: "加载中...")
                })
        } else {
            self.performSegueWithIdentifier(StoryBoard.Segues.pickBook, sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.Segues.showDetail {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let indexItem = bookItem.indexes[indexPath.row]
                var index = 0
                for (key, value) in enumerate(bookItem.pages) {
                    if value.link == indexItem.link {
                        index = key
                        break
                    }
                }
                (segue.destinationViewController as! PageViewController).setPages(bookItem.pages, atIndex: index)
            }
        }
    }

    // MARK: - Table View

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        if cell.selectionStyle != UITableViewCellSelectionStyle.None {
            performSegueWithIdentifier(StoryBoard.Segues.showDetail, sender: self)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookItem.indexes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let indexItem = bookItem.indexes[indexPath.row]
        let title = Utility.cleanString(indexItem.title)
        var cellIdentifier = StoryBoard.Cells.cell
        if indexItem.title != title {
            cellIdentifier = StoryBoard.Cells.cellBold
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = title
        cell.detailTextLabel!.text = indexItem.page == 0 ? "" : "\(indexItem.page)"
        if indexItem.link.isEmpty {
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = UITableViewCellAccessoryType.None
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyle.Default
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
}

