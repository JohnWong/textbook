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
    
    func setPages(_ pages: Array<IndexItem>, atIndex index: Int) {
        self.pages = pages
        self.index = index
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        let detailItem = pages[index]
        title = Utility.cleanString(detailItem.title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        configureView()
        for _ in 0...1 {
            let controller: AnyObject! = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Page")
            if let controller = controller as? ImageViewController {
                tempControllers.append(controller)
            }
        }
        let imageController = tempControllers[0]
        imageController.imagePath = pages[index].link

        setViewControllers(Array<ImageViewController>(arrayLiteral: imageController), direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: { (result: Bool) -> Void in
            
        })
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if !pageAnimationFinished || index == 0 {
            return nil
        }
        let controller = viewController == tempControllers[0] ? tempControllers[1] : tempControllers[0]
        controller.index = index - 1
        let item = pages[controller.index]
        controller.imagePath = item.link
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if !pageAnimationFinished || index == pages.count - 1 {
            return nil
        }
        let controller = viewController == tempControllers[0] ? tempControllers[1] : tempControllers[0]
        controller.index = index + 1
        let item = pages[controller.index]
        controller.imagePath = item.link
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        pageAnimationFinished = false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let controller = pageViewController.viewControllers![0] as? ImageViewController {
            index = controller.index
        }
        configureView()
        pageAnimationFinished = true
    }
    
}
