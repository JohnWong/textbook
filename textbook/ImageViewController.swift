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
    var imagePath: String = "" {
        willSet(newImagePath) {
            self.setImagePathIfExists(newImagePath)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImagePathIfExists(imagePath)
    }
    
    func setImagePathIfExists(url: String) {
        if let imageView = self.imageView {
            self.imageView.setImageWithURL(NSURL(string: url as String), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        }
    }
    
}
