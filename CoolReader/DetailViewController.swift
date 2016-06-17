//
//  DetailViewController.swift
//  CoolReader
//
//  Created by Austin Felipe on 2016-06-16.
//  Copyright © 2016 Austin Felipe. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        let urlString = detailItem?.objectForKey("url") as! String
        
        if let web = self.webView {
            web.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

