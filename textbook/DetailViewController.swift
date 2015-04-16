//
//  DetailViewController.swift
//  textbook
//
//  Created by John Wong on 4/16/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLayoutSubviews() {
        self.scrollView.frame = self.view.bounds
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        let window = UIApplication.sharedApplication().delegate?.window
        window!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
