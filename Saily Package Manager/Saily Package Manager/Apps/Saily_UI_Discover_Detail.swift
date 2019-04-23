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
    @IBOutlet weak var loading_bg: UIImageView!
    @IBOutlet weak var loading_mafufu: UIImageView!
    @IBOutlet weak var loading_eoung: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        web_container.navigationDelegate = self
        
        if (self.discover_index == -666) {
            let url = URL(string: Saily.app_web_site)!
            web_container.load(URLRequest(url: url))
            web_container.allowsBackForwardNavigationGestures = true
            let wix_cover = UIImageView()
            wix_cover.image = #imageLiteral(resourceName: "BGBlue.png")
            wix_cover.contentMode = .scaleAspectFill
            wix_cover.clipsToBounds = true
            self.view.addSubview(wix_cover)
            self.view.bringSubviewToFront(wix_cover)
            wix_cover.snp.makeConstraints { (c) in
                c.top.equalTo(self.view.snp.top)
                c.left.equalTo(self.view.snp.left)
                c.right.equalTo(self.view.snp.right)
                c.height.equalTo(38)
            }
        }else{
            if (!Saily.discover_root[discover_index].web_link.uppercased().contains("HTTP")) {
            let url_dead = UIImageView()
            url_dead.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
            url_dead.contentMode = .scaleAspectFit
            url_dead.clipsToBounds = false
            self.view.addSubview(url_dead)
            self.view.bringSubviewToFront(url_dead)
            url_dead.snp.makeConstraints { (c) in
                c.center.equalTo(self.view.snp.center)
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
                    c.center.equalTo(self.view.snp.center)
                }
                
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.5, animations: {
            self.loading_eoung.alpha = 0
            self.loading_mafufu.alpha = 0
            self.loading_bg.alpha = 0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loading_eoung.isHidden = true
            self.loading_mafufu.isHidden = true
            self.loading_bg.isHidden = true
        }
        self.web_container.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.web_container.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("[*] This web page is with height: " + height.debugDescription)
                })
            }
            
        })
    }
    
    var isBeginTouchPositionSet = false
    var beginTouchPosition = CGPoint()
    var endTouchPosition = CGPoint()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { exit(62) }
        var touches = [UITouch]()
        if let coalescedTouches = event?.coalescedTouches(for: touch){
            touches = coalescedTouches
        }else{
            touches.append(touch)
        }
        if (isBeginTouchPositionSet == false) {
            beginTouchPosition = (touches.first?.location(in: self.view))!
            isBeginTouchPositionSet = true
        }
        endTouchPosition = (touches.last?.location(in: self.view))!
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeginTouchPositionSet = false
        
        // 上滑手势
        if (abs(Int(beginTouchPosition.x - endTouchPosition.x)) < 120 && (beginTouchPosition.y - endTouchPosition.y) > 45 ) {
            beginTouchPosition = CGPoint(x: 0, y: 0)
            endTouchPosition = CGPoint(x: 0, y: 0)
            print("[*] Going up~")
            return
        }
        // 下滑手势
        if (abs(Int(beginTouchPosition.x - endTouchPosition.x)) < 120 && (beginTouchPosition.y - endTouchPosition.y) < -45 ) {
            beginTouchPosition = CGPoint(x: 0, y: 0)
            endTouchPosition = CGPoint(x: 0, y: 0)
            print("[*] Going down~")
            return
        }
    }
    
}
