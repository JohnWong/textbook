//
//  ImageViewController.swift
//  textbook
//
//  Created by John Wong on 4/15/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var index = 0
    
    var imagePath: String = "" {
        willSet(newImagePath) {
            setImagePathIfExists(newImagePath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePathIfExists(imagePath)
    }
    
    func setImagePathIfExists(url: String) {
        println("\(url)")
        if let scrollView = scrollView {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
        if let imageView = imageView {
            imageView.setImageWithURL(NSURL(string: url as String), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.imageWidthConstraint.constant = self.view.frame.width
        super.viewWillLayoutSubviews()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller: AnyObject! = segue.destinationViewController;
        if let controller = controller as? DetailViewController {
            controller.imagePath = imagePath
        }
    }
}
