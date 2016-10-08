//
//  WebViewController.swift
//  textbook
//
//  Created by John Wong on 4/25/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var urlPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshWebView(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.cancelSGProgress()
    }
    
    @IBAction func refreshWebView(_ sender: AnyObject?) {
        self.webView.stopLoading()
        self.navigationItem.title = "加载中...";
        self.navigationController?.showSGProgress(withDuration: 5.0)
        let url = URL(string: urlPath!)
        self.webView.loadRequest(URLRequest(url: url!))
    }
    
    // MARK: web view delegate
    
    func webViewDidFinishLoad(_ webVIew: UIWebView) {
    self.navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        self.navigationController!.finishSGProgress()
    }

}
