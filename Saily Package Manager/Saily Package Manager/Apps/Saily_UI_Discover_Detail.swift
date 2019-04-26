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
import NVActivityIndicatorView

class Saily_UI_Discover_Detail: UIViewController, WKNavigationDelegate{
    
    public var discover_index = Int()
    @IBOutlet weak var web_container: WKWebView!
    let loading_view = NVActivityIndicatorView(frame: CGRect(), type: .circleStrokeSpin, color: #colorLiteral(red: 0.01864526048, green: 0.4776622653, blue: 1, alpha: 1), padding: nil)
    
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
        self.view.addSubview(loading_view)
        loading_view.snp.makeConstraints { (c) in
            c.bottom.equalTo(self.view.snp.bottom).offset(-18 - (self.tabBarController?.tabBar.bounds.height ?? 8))
            c.right.equalTo(self.view.snp.right).offset(-18)
            c.width.equalTo(23)
            c.height.equalTo(23)
        }
        loading_view.startAnimating()
    }
    
    func show_tweaks(withName: String) {
        
        let package = Saily.search_a_package_with(its_name: withName)
        
        let tweak_view = UIView()
        tweak_view.backgroundColor = .clear
        tweak_view.alpha = 0
        tweak_view.setRadius(radius: 20)
        self.view.addSubview(tweak_view)
        tweak_view.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(28)
            x.right.equalTo(self.view.snp.right).offset(-28)
            x.bottom.equalTo(self.view.snp.bottom).offset(-18 - (self.tabBarController?.tabBar.bounds.height ?? 88))
            x.height.equalTo(66)
        }
        
        let visual_effect = UIBlurEffect(style: .extraLight)
        let effect_view = UIVisualEffectView(effect: visual_effect)
        tweak_view.addSubview(effect_view)
        effect_view.snp.makeConstraints { (x) in
            x.top.equalTo(tweak_view.snp.top)
            x.bottom.equalTo(tweak_view.snp.bottom)
            x.right.equalTo(tweak_view.snp.right)
            x.left.equalTo(tweak_view.snp.left)
        }
        
        let image = UIImageView.init(image: #imageLiteral(resourceName: "iConRound.png"))
        tweak_view.addSubview(image)
        tweak_view.contentMode = .scaleAspectFit
        image.snp.makeConstraints { (x) in
            x.left.equalTo(tweak_view.snp.left).offset(8)
            x.top.equalTo(tweak_view.snp.top).offset(8)
            x.bottom.equalTo(tweak_view.snp.bottom).offset(-8)
            x.width.equalTo(image.snp.height)
        }
        
        let name = UILabel()
        name.text = package?.info["NAME"] ?? withName
        name.textColor = .darkGray
        name.font = .boldSystemFont(ofSize: 18)
        tweak_view.addSubview(name)
        name.snp.makeConstraints { (x) in
            x.left.equalTo(image.snp.right).offset(8)
            x.right.equalTo(tweak_view.snp.right).offset(-72)
            x.centerY.equalTo(image.snp.centerY).offset(-8)
            x.height.equalTo(24)
        }
        
        
        let repo = UILabel()
        repo.text = package?.fater_repo.ress.major ?? Saily.discover_root[self.discover_index].tweak_repo
        repo.textColor = .lightGray
        repo.font = .boldSystemFont(ofSize: 10)
        tweak_view.addSubview(repo)
        repo.snp.makeConstraints { (x) in
            x.left.equalTo(image.snp.right).offset(10)
            x.right.equalTo(tweak_view.snp.right).offset(-66)
            x.centerY.equalTo(image.snp.centerY).offset(10)
            x.height.equalTo(24)
        }
        
        let add_button = UIButton()
        add_button.setTitleColor(.white, for: .normal)
        add_button.setTitleColor(.gray, for: .focused)
        add_button.setTitle("GET".localized(), for: .normal)
        add_button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        add_button.backgroundColor = #colorLiteral(red: 0.07285261899, green: 0.5867173076, blue: 0.8592197895, alpha: 1)
        add_button.setRadius(radius: 14)
        tweak_view.addSubview(add_button)
        add_button.snp.makeConstraints { (x) in
            x.right.equalTo(tweak_view.snp.right).offset(-8)
            x.top.equalTo(tweak_view.snp.top).offset(18)
            x.bottom.equalTo(tweak_view.snp.bottom).offset(-18)
            x.left.equalTo(name.snp.right).offset(14)
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                tweak_view.alpha = 1
            })
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.web_container.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.web_container.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("[*] This web page is with height: " + height.debugDescription)
                })
            }
        })
        
        loading_view.stopAnimating()
        if (Saily.discover_root[self.discover_index].tweak_id != "") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.show_tweaks(withName: Saily.discover_root[self.discover_index].tweak_id)
            }
        }
        
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
