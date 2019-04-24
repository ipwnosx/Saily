//
//  Saily_UI_Tweak_Webkit.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/22.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit
import WebKit

import Alamofire
import NVActivityIndicatorView

class Saily_UI_Tweak_Webkit: UIViewController, WKNavigationDelegate {

    public var this_package: packages_C? = nil
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var Imager: UIImageView!
    @IBOutlet weak var this_Web: WKWebView!
    @IBOutlet weak var this_web_is_tall: NSLayoutConstraint!
    @IBOutlet weak var bundleID: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var container_info_view: UIView!
    @IBOutlet weak var button: UIButton!
    
    var finish_load = false
    
    let loading_view = NVActivityIndicatorView(frame: CGRect(), type: .circleStrokeSpin, color: #colorLiteral(red: 0.01864526048, green: 0.4776622653, blue: 1, alpha: 1), padding: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "⁠ ⁠Package 📦💨".localized
        
        button.setRadius(radius: 15)
        button.snp.makeConstraints { (c) in
            c.centerY.equalTo(self.Imager.snp.centerY)
        }
        
        print("[*] Catch package info:")
        print(self.this_package?.info as Any)
        
        bundleID.text = (this_package?.info["PACKAGE"] ?? "Error: 0xbad10ac1a0e1d - BAD PACKAGE ID") + "\n\n Saily Package Manager & Lakr Aream 2019.4"
        bundleID.numberOfLines = 3
        bundleID.lineBreakMode = .byWordWrapping
        
        Imager.image = #imageLiteral(resourceName: "BGBlue.png")
        
        this_Web.navigationDelegate = self
        
        name.lineBreakMode = .byWordWrapping
        name.text = this_package?.info["NAME"] ?? "No Name Boy".localized()
        
        icon.image = #imageLiteral(resourceName: "tweaksss.png")
//        icon.backgroundColor = .white
        icon.setRadius(radius: 8)
        icon.addShadow(ofColor: .gray, radius: 6, offset: CGSize(width: 0, height: 0), opacity: 0.5)
        
        let str = "Version: ".localized() + (this_package?.info["VERSION"] ?? "nil") + "\n"
        
        desc.text = str + (this_package?.info["DESCRIPTION"] ?? "No description found within the database.".localized())
        
        container_info_view.addShadow(ofColor: .gray, radius: 6, offset: CGSize(width: 0, height: 0), opacity: 0.5)
        
        guard let depiction = self.this_package?.info["DEPICTION"] else {
            let non_view = UIImageView()
            non_view.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
            non_view.contentMode = .scaleAspectFit
            self.container.addSubview(non_view)
            non_view.snp.makeConstraints { (c) in
                c.center.equalTo(self.this_Web.snp.center)
                c.width.equalTo(128)
                c.height.equalTo(128)
            }
            let non_connection = UILabel.init(text: "Error: -0x000de01c210n - No DEPICTION URL")
            non_connection.textColor = .gray
            non_connection.font = .boldSystemFont(ofSize: 12)
            self.container.addSubview(non_connection)
            non_connection.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.this_Web.snp.centerX)
                x.top.equalTo(non_view.snp.bottom).offset(28)
                x.height.equalTo(25)
            }
            return
        }
        if let urldep = URL.init(string: depiction) {
            print("[*] Attempt to connect for depiction: " + urldep.description)
            self.loadWebPage(url: urldep)
            
//            let h: HTTPHeaders  = ["User-Agent" : CydiaNetwork.UA_Web_Request_iOS_12,
//                                   "X-Firmware" : CydiaNetwork.H_Firmware,
//                                   "X-Unique-ID" : CydiaNetwork.H_UDID,
//                                   "X-Machine" : CydiaNetwork.H_Machine,
//                                   "Accept" : "*/*",
//                                   "Accept-Language" : "zh-CN,en,*",
//                                   "Accept-Encoding" : "gzip, deflate"]
//
//            AF.request(urldep, headers: h).responseString { (data) in
//                if let data_str = data.value {
//                    self.this_Web.loadHTMLString(data_str, baseURL: urldep)
//                }
//            }
            
            this_Web.scrollView.isScrollEnabled = false
            self.view.addSubview(loading_view)
            loading_view.snp.makeConstraints { (c) in
                c.centerX.equalTo(self.this_Web.snp.centerX)
                c.top.equalTo(self.this_Web.snp.top).offset(-10)
                c.width.equalTo(23)
                c.height.equalTo(23)
            }
            loading_view.startAnimating()
        }else{
            let non_view = UIImageView()
            non_view.image = #imageLiteral(resourceName: "mafumafu_dead_rul.png")
            non_view.contentMode = .scaleAspectFit
            self.container.addSubview(non_view)
            non_view.snp.makeConstraints { (c) in
                c.center.equalTo(self.this_Web.snp.center)
                c.width.equalTo(128)
                c.height.equalTo(128)
            }
            let non_connection = UILabel.init(text: "Error: -0xbadde01c210n - BAD DEPICTION URL")
            non_connection.textColor = .gray
            non_connection.font = .boldSystemFont(ofSize: 12)
            self.container.addSubview(non_connection)
            non_connection.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.this_Web.snp.centerX)
                x.top.equalTo(non_view.snp.bottom).offset(28)
                x.height.equalTo(25)
            }
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.this_Web.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                if complete != nil {
                    self.this_Web.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        print("[*] This web page is with height: " + height.debugDescription)
                        if (self.finish_load == false) {
                            if let h = height as? CGFloat {
                                if (h != 0) {
                                    self.this_web_is_tall.constant = h
                                }
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    
    func loadWebPage(url: URL)  {
        self.loadUrl = url
        var customRequest = URLRequest(url: url)
        customRequest.setValue("zh-CN,en,*", forHTTPHeaderField: "Accept-Language")
        customRequest.setValue("*/*", forHTTPHeaderField: "Accept")
        customRequest.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        customRequest.setValue(CydiaNetwork.H_Firmware, forHTTPHeaderField: "X-Firmware")
        customRequest.setValue(CydiaNetwork.H_UDID, forHTTPHeaderField: "X-Unique-ID")
        customRequest.setValue(CydiaNetwork.H_Machine, forHTTPHeaderField: "X-Machine")
        customRequest.setValue("1", forHTTPHeaderField: "Upgrade-Insecure-Requests")
        customRequest.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        customRequest.setValue("1556.00", forHTTPHeaderField: "X-Cydia-Cf")
        customRequest.timeoutInterval = 8
        this_Web.customUserAgent = CydiaNetwork.UA_Web_Request_Longer
        this_Web!.load(customRequest)
    }
    
    // MARK: - WKNavigationDelegate
    var loadUrl = URL(string: "https://www.google.com/")!
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = (navigationResponse.response as! HTTPURLResponse).url else {
            decisionHandler(.cancel)
            return
        }
        if url != loadUrl {
            loadUrl = url
            decisionHandler(.cancel)
            loadWebPage(url: url)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.this_Web.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.this_Web.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    print("[*] This web page is with height: " + height.debugDescription)
                    self.this_web_is_tall.constant = height as! CGFloat
                    self.finish_load = true
                })
            }
        })
        
        loading_view.stopAnimating()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

