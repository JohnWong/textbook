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
            setImagePathIfExists(newImagePath)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePathIfExists(imagePath)
    }
    
    func setImagePathIfExists(url: String) {
        if let imageView = imageView {
            imageView.setImageWithURL(NSURL(string: url as String), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        }
    }
    
}
