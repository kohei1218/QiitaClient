//
//  WebViewController.swift
//  QiitaClient
//
//  Created by kohei saito on 2019/04/28.
//  Copyright © 2019 kohei saito. All rights reserved.
//

import UIKit
import WebKit
import Instantiate
import InstantiateStandard

class WebViewController: UIViewController, StoryboardInstantiatable {

    @IBOutlet weak var webView: WKWebView!
    var request: URLRequest!
    
    func inject(_ dependency: WebViewController.Dependency) {
        self.request = URLRequest(url: dependency.url)
    }
    
    struct Dependency {
        var url: URL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.load(request)
    }
}
