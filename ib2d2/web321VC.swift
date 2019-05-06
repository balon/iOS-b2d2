//
//  web321VC.swift
//  ib2d2
//
//  Created by balon on 4/28/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import WebKit

class web321VC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "BackBlaze on 3-2-1"
        
        // View the BackBlaze Website
        let webView = WKWebView()
        let webUrl = URL(string: "https://www.backblaze.com/blog/the-3-2-1-backup-strategy")
        
        webView.navigationDelegate = self
        view = webView
        webView.scrollView.isScrollEnabled = true
        webView.load(URLRequest(url: webUrl!))
        webView.reload()
    }

}
