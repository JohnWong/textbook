//
//  NavigationViewController.swift
//  textbook
//
//  Created by John Wong on 4/25/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    let webUrls = [
        "http://impress.sinaapp.com/textbook/about.html",
        "http://impress.sinaapp.com/textbook/help.html",
        "http://impress.sinaapp.com/textbook/privacy.html"]
    var selectedUrl: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if selectedUrl >= 0 && selectedUrl < webUrls.count {
            let webViewController: WebViewController = segue.destinationViewController as! WebViewController
            webViewController.urlPath = webUrls[selectedUrl]
        }
    }

}
