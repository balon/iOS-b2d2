//
//  webHandlerVC.swift
//  ib2d2
//
//  Created by balon on 5/9/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import WebKit

class webHandlerVC: UIViewController, WKNavigationDelegate{
    @IBOutlet weak var webView: WKWebView!
    var webTitle: String = ""
    var webUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.webTitle
        
        // View the BackBlaze Website
        let webView = WKWebView()
        let visitURL = URL(string: self.webUrl)
        
        webView.navigationDelegate = self
        view = webView
        webView.scrollView.isScrollEnabled = true
        webView.load(URLRequest(url: visitURL!))
        webView.reload()
    }
}
