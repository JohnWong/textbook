//
//  MasterViewController.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects: Array<NSDictionary> = [NSDictionary]()
    var indexRequest = IndexRequest()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        indexRequest.loadWithCompletion { (dict, error) -> Void in
            if let dict = dict {
                self.objects = dict["index"] as! Array<NSDictionary>
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
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = objects[indexPath.row] as! NSDate
//            (segue.destinationViewController as! DetailViewController).detailItem = object
//            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object: NSDictionary = objects[section]
        if let rows: NSArray = object["rows"] as? NSArray {
            return rows.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object: NSDictionary = objects[indexPath.section]
        if let rows: NSArray = object["rows"] as? NSArray {
            if let item: NSDictionary = rows[indexPath.row] as? NSDictionary {
                cell.textLabel!.text = item["title"] as? String
                return cell
            }
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

