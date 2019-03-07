//
//  WebViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 3/12/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var url: URL?
    var websiteTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: self.url!))
        webView.delegate = self
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
    }

}
