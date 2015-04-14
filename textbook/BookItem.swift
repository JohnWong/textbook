//
//  BookItem.swift
//  textbook
//
//  Created by John Wong on 4/13/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import Foundation

class IndexItem {
    
    let title: String
    let link: String
    let page: Int
    let prev: String
    let next: String
    
    init(title: String, link: String, page: Int, prev: String, next: String) {
        self.title = title
        self.link = link
        self.page = page
        self.prev = prev
        self.next = next
    }
    
    convenience init() {
        self.init(title: "", link: "", page: 0, prev: "", next: "")
    }
}

class SectionItem {
    
    let header: String
    let rows: Array<IndexItem>
    
    init(header: String, rows: Array<IndexItem>) {
        self.header = header
        self.rows = rows
    }
    
    convenience init(dict: NSDictionary) {
        let header: String = dict["header"] as! String
        let rows: NSArray = dict["rows"] as! NSArray
        var tempItems = Array<IndexItem>()
        for itemDict in rows {
            if let itemDict: NSDictionary = itemDict as? NSDictionary {
                let title: String = itemDict["title"] is String ? itemDict["title"] as! String : ""
                let link: String = itemDict["link"] is String ? itemDict["link"] as! String : ""
                let page: Int = itemDict["page"] as! Int
                let prev: String = itemDict["prev"] is String ? itemDict["prev"] as! String : ""
                let next: String = itemDict["next"] is String ? itemDict["next"] as! String : ""
                let indexItem = IndexItem(title: title, link: link, page: page, prev: prev, next: next)
                tempItems.append(indexItem)
            }
        }
        self.init(header: header, rows: tempItems)
    }
}

class BookItem {
    
    let name: String
    let sectionItems: Array<SectionItem>
    
    init(name: String, sectionItems: Array<SectionItem>) {
        self.name = name
        self.sectionItems = sectionItems
    }
    
    convenience init() {
        self.init(name: "", sectionItems: Array<SectionItem>())
    }
    
    convenience init(dict: NSDictionary) {
        let name: String = dict["name"] as! String
        let sections: NSArray? = dict["sections"] as? NSArray
        var tempItems = Array<SectionItem>()
        if let sections = sections {
            for itemDict in sections {
                if let itemDict: NSDictionary = itemDict as? NSDictionary {
                    let section = SectionItem(dict: itemDict)
                    tempItems.append(section)
                }
            }
        }
        self.init(name: name, sectionItems: tempItems)
    }
}