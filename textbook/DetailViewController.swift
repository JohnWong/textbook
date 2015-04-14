//
//  DetailViewController.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var indexes: Array<IndexItem> = []
    var index: Int = 0

    func setIndexes(indexes: Array<IndexItem>, atIndex index: Int) {
        self.indexes = indexes
        self.index = index
    }

    func configureView() {
        // Update the user interface for the detail item.
        let detailItem = self.indexes[index]
        self.title = detailItem.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

