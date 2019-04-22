//
//  Saily_UI_Discover_Detail.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/22.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit
import WebKit

import Hero

class Saily_UI_Discover_Detail: UIViewController, WKNavigationDelegate{
    
    public var discover_index = Int()
    @IBOutlet weak var web_container: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        web_container.navigationDelegate = self
        
        
        
        if (self.discover_index == -666) {
            let url = URL(string: Saily.app_web_site)!
            web_container.load(URLRequest(url: url))
            web_container.allowsBackForwardNavigationGestures = true
        }else{
            if (!Saily.discover_root[discover_index].web_link.uppercased().contains("HTTP")) {
            let url_dead = UIImageView()
            url_dead.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
            url_dead.contentMode = .scaleAspectFit
            url_dead.clipsToBounds = false
            self.view.addSubview(url_dead)
            self.view.bringSubviewToFront(url_dead)
            url_dead.snp.makeConstraints { (c) in
                c.center.equalTo(self.view.snp_center)
                c.width.equalTo(233)
            }
            return
            }
            if let url = URL(string: Saily.discover_root[discover_index].web_link) {
                web_container.load(URLRequest(url: url))
                web_container.allowsBackForwardNavigationGestures = true
            }else{
                let url_dead = UIImageView()
                url_dead.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
                url_dead.contentMode = .scaleAspectFit
                url_dead.clipsToBounds = false
                self.view.addSubview(url_dead)
                self.view.bringSubviewToFront(url_dead)
                url_dead.snp.makeConstraints { (c) in
                    c.center.equalTo(self.view.snp_center)
                }
                
            }
        }
        
    }
    
    
}
