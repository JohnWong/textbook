//
//  DetailViewController.swift
//  textbook
//
//  Created by John Wong on 4/16/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!    
    
    var imagePath: String = "" {
        willSet(newImagePath) {
            setImagePathIfExists(newImagePath)
        }
    }
    @IBOutlet var singleTapGesture: UITapGestureRecognizer!
    
    @IBOutlet var doubleTapGesture: UITapGestureRecognizer!
    
    override func viewDidLayoutSubviews() {
        self.imageWidthConstraint.constant = self.view.frame.size.width
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = min(1, self.view.frame.size.height / (imageView.frame.size.height / imageView.frame.size.width * self.view.frame.size.width))
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didDoubleTap(sender: AnyObject) {
        scrollView.zoomScale = scrollView.zoomScale * 1.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePathIfExists(imagePath)
        singleTapGesture.requireGestureRecognizerToFail(doubleTapGesture)
    }
    
    func setImagePathIfExists(url: String) {
        if let imageView = imageView {
            imageView.setImageWithURL(NSURL(string: url as String), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        adjustViewCenter()
    }
    
    func adjustViewCenter() {
        var offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width ) / 2
        var offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) / 2
        imageView.center = scrollView.center
        println("\(scrollView.contentSize.width/2 + offsetX), \(offsetY)")
    }
}
