//
//  DetailViewController.swift
//  textbook
//
//  Created by John Wong on 4/12/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func setBookItem(bookItem: BookItem, )
    

    func configureView() {
        // Update the user interface for the detail item.
        if let label = self.detailDescriptionLabel {
            label.text = detailItem.title
        }
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

