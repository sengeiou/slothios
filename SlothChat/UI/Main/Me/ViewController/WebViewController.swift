//
//  WebViewController.swift
//  SlothChat
//
//  Created by 王一丁 on 2017/3/3.
//  Copyright © 2017年 ssloth.com. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    let wkWebView:WKWebView = WKWebView.init();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "最终用户许可协议";
        self.wkWebView.frame = self.view.bounds;
        self.view.addSubview(self.wkWebView);
        // Do any additional setup after loading the view.
        let path:String? = Bundle.main.path(forResource: "EULA", ofType: "html", inDirectory: nil, forLocalization: nil);
        self.wkWebView.loadFileURL(NSURL.fileURL(withPath: path!), allowingReadAccessTo: NSURL.fileURL(withPath: path!));
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
