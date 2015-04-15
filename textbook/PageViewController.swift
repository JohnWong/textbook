//
//  PageViewController.swift
//  textbook
//
//  Created by John Wong on 4/15/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var tempControllers = Array<ImageViewController> ()
    var pages: Array<IndexItem> = []
    var index: Int = 0
    var pageAnimationFinished = true
    
    func setPages(pages: Array<IndexItem>, atIndex index: Int) {
        self.pages = pages
        self.index = index
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        let detailItem = self.pages[index]
        self.title = detailItem.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.configureView()
        for i in 0...1 {
            let controller: AnyObject! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Page")
            if let controller = controller as? ImageViewController {
                tempControllers.append(controller)
            }
        }
        let imageController = tempControllers[0]
        imageController.imagePath = self.pages[index].link

        self.setViewControllers(Array<ImageViewController>(arrayLiteral: imageController), direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (result: Bool) -> Void in
            
        })
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if !pageAnimationFinished || index == 0 {
            return nil
        }
        let controller = viewController == tempControllers[0] ? tempControllers[1] : tempControllers[0]
        let item = self.pages[--index]
        controller.imagePath = item.link
        configureView()
        return controller
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if !pageAnimationFinished || index == self.pages.count - 1 {
            return nil
        }
        let controller = viewController == tempControllers[0] ? tempControllers[1] : tempControllers[0]
        let item = self.pages[++index]
        controller.imagePath = item.link
        configureView()
        return controller
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        pageAnimationFinished = false
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        pageAnimationFinished = true
    }
    
}
