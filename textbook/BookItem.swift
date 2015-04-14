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
    
    init(title: String, link: String, page: Int) {
        self.title = title
        self.link = link
        self.page = page
    }
    
    convenience init() {
        self.init(title: "", link: "", page: 0)
    }
    
    convenience init(dict: NSDictionary) {
        let title: String = dict["title"] is String ? dict["title"] as! String : ""
        let link: String = dict["link"] is String ? dict["link"] as! String : ""
        let page: Int = dict["page"] as! Int
        let indexItem = IndexItem(title: title, link: link, page: page)
        self.init(title: title, link: link, page: page)
    }
}

class BookItem {
    
    let name: String
    let indexes: Array<IndexItem>
    let pages: Array<IndexItem>
    
    init(name: String, indexes: Array<IndexItem>, pages: Array<IndexItem>) {
        self.name = name
        self.indexes = indexes
        self.pages = pages
    }
    
    convenience init() {
        self.init(name: "", indexes: Array<IndexItem>(), pages: Array<IndexItem>())
    }
    
    convenience init(dict: NSDictionary) {
        let name: String = dict["name"] as! String
        let pageArray: NSArray? = dict["pages"] as? NSArray
        var pages = Array<IndexItem>()
        var indexes = Array<IndexItem>()
        if let pageArray = pageArray {
            for page in pageArray {
                if let page: NSDictionary = page as? NSDictionary {
                    let indexItem = IndexItem(dict: page)
                    if (indexItem.title.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) != nil) {
                        indexes.append(indexItem)
                    }
                    
                    var title = indexItem.title.stringByReplacingOccurrencesOfString("<b>", withString: "").stringByReplacingOccurrencesOfString("</b>", withString: "")
                    pages.append(IndexItem(title: title, link: indexItem.link, page: indexItem.page))
                    
                }
            }
        }
        self.init(name: name, indexes: indexes, pages: pages)
    }
}