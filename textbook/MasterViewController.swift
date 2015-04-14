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
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let indexItem = bookItem.sectionItems[indexPath.section].rows[indexPath.row]
                (segue.destinationViewController as! DetailViewController).detailItem = indexItem
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return bookItem.sectionItems.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookItem.sectionItems[section].rows.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let indexItem = bookItem.sectionItems[indexPath.section].rows[indexPath.row]
        cell.textLabel!.text = indexItem.title
        cell.detailTextLabel!.text = indexItem.page == 0 ? "" : "\(indexItem.page)"
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return bookItem.sectionItems[section].header
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return bookItem.sectionItems[section].header.isEmpty ? 0 : 36
    }
}

