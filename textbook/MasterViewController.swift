//
//  MasterViewController.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var bookItem = BookItem()
    var bookRequest = BookRequest()
    
    struct StoryBoard {
         struct Cells {
            static let cell = "Cell"
            static let cellBold = "CellBold"
        }
        
         struct Segues {
            static let showDetail = "showDetail"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookRequest.loadWithCompletion { (dict, error) -> Void in
            if let dict = dict {
                self.bookItem = BookItem(dict: dict)
                self.title = self.bookItem.name
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoard.Segues.showDetail {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
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
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)!
        if cell.selectionStyle != UITableViewCellSelectionStyle.None {
            self.performSegueWithIdentifier(StoryBoard.Segues.showDetail, sender: self)
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
        let title = indexItem.title.stringByReplacingOccurrencesOfString("<b>", withString: "").stringByReplacingOccurrencesOfString("</b>", withString: "")
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

