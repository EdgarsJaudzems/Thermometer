//
//  WebViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 24/02/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    var urlString = String()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebKit"
        
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        guard let activityIndicator = activity else { return }
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        guard let activityIndicator = activity else { return }
//        activityIndicator.isHidden = true
//        activityIndicator.stopAnimating()
//    }
}
