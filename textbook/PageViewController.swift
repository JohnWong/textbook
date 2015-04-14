//
//  PageViewController.swift
//  textbook
//
//  Created by John Wong on 4/15/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        
        self.dataSource = self
        
        var viewControllers = Array<UIViewController>()
        for i in 1...1 {
            let viewController: AnyObject! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Page")
            if let viewController = viewController as? UIViewController {
                viewController.view.backgroundColor = UIColor.greenColor()
                viewControllers.append(viewController)
            }
        }
        
        self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: { (result: Bool) -> Void in
            print("\(result)")
        })
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.redColor()
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blueColor()
        return vc
    }
}
