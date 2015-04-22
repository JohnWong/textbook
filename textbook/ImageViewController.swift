//
//  ImageViewController.swift
//  textbook
//
//  Created by John Wong on 4/15/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var index = 0
    
    var imagePath: String = "" {
        willSet(newImagePath) {
            setImagePathIfExists(newImagePath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePathIfExists(imagePath)
        initGestures()
        initScrollView()
    }
    
    func initScrollView() {
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.zoomScale = 1
        scrollView.delegate = self
    }
    
    func initGestures() {
        var singleTap = UITapGestureRecognizer(target: self, action: Selector("didSingleTap"))
        var doubleTap = UITapGestureRecognizer(target: self, action: Selector("didDoubleTap"))
        doubleTap.numberOfTapsRequired = 2
        singleTap.requireGestureRecognizerToFail(doubleTap)
        self.view.addGestureRecognizer(singleTap)
        self.view.addGestureRecognizer(doubleTap)
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
    
    func didSingleTap() {
        scrollView.zoomScale = 1
    }
    
    func didDoubleTap() {
        if scrollView.zoomScale != scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        } else {
            scrollView.zoomScale = 1
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillLayoutSubviews() {
        self.imageWidthConstraint.constant = self.view.frame.width
        self.imageHeightConstraint.constant = self.view.frame.height
        super.viewWillLayoutSubviews()
    }
}
