//
//  initViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import Alamofire
import LTMorphingLabel

class initViewController: UIViewController, LTMorphingLabelDelegate {
    
    @IBOutlet weak var mainProgressBar: UIProgressView!
    @IBOutlet weak var tipLabel: LTMorphingLabel!
    @IBOutlet weak var tipSubLabel: LTMorphingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tipLabel.delegate = self
        self.tipLabel.morphingEffect = .evaporate
        self.tipSubLabel.morphingEffect = .evaporate
        if (shouldAppDisableEffect) {
            self.tipLabel.morphingEnabled = false
            self.tipSubLabel.morphingEnabled = false
        }else{
            self.tipLabel.morphingEnabled = true
            self.tipSubLabel.morphingEnabled = true
        }
        DispatchQueue.main.async {
            checkNetwork()
            if (!canTheAppAccessNetWork) {
                let alert = UIAlertController.init(title: "No Internet Connectiosn", message: "If you are offline, dismiss it. If there is something wrong with network permission? Try to fix it.", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Fix It", style: .cancel, handler: { (_) in
                    let files = try? FileManager.default.contentsOfDirectory(atPath: "/var/preferences/com.apple.networkextension")
                    for item in files ?? [String]() {
                        try? FileManager.default.removeItem(atPath: item)
                    }
                    let alert = UIAlertController.init(title: "Fix applied if I can.", message: "You may reboot to see it.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "Fine", style: .cancel, handler: { (_) in
                        exit(0)
                    }))
                    self.present(alert, animated: true , completion: nil)
                }))
                alert.addAction(UIAlertAction.init(title: "Dismiss", style: .default, handler: { (_) in
                    checkNetwork()
                    if (canTheAppAccessNetWork == true) {
                        DispatchQueue.main.async {
                            self.viewDidLoad()
                        }
                        return
                    }else{
                        self.restOfSetup()
                    }
                }))
                self.present(alert, animated: true , completion: nil)
            }else{
                self.restOfSetup()
            }
        }

    }
    
    func restOfSetup() -> Void {
        
        var ret = returnStatusSuccess
        
        self.tipLabel.text = "Checking your system if"
        self.tipSubLabel.text = "there is any thing wrong that we might to deal later."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute:
            {
                UIView.animate(withDuration: 0.1, animations: {
                    self.mainProgressBar.progress = 0.15
                })
                ret = initCheck()
                
                if (!FileManager.default.fileExists(atPath: appRootFileSystem + "/ud.id")) {
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        for item in self.view.subviews {
                            item.alpha = 0
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "UDIDViewController_StoryBoard_REG_ID")
                        appDelegate.window?.rootViewController = initialViewController
                        appDelegate.window?.makeKeyAndVisible()
                        return
                    })
                    return
                }else{
                    deviceInfo_UDID = try! String.init(contentsOfFile: appRootFileSystem + "/ud.id")
                }
                
                DispatchQueue.main.async
                    {
                        UIView.animate(withDuration: 0.1, animations: {
                            self.mainProgressBar.progress = 0.233
                        })
                        self.tipLabel.text = "Refreshing repos..."
                        self.tipSubLabel.text = "This might take a while affected by your network."
                        
                        ret = refreshRepos()
                        
                        DispatchQueue.main.async
                            {
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.mainProgressBar.progress = 0.666
                                })
                                self.tipLabel.text = "Detecting dpkg status..."
                                self.tipSubLabel.text = "We will fix error(s) if we have some."
                                ret = initCheck_dpkg()
                                
                                DispatchQueue.main.async {
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.mainProgressBar.progress = 1.0
                                    })
                                    self.tipSubLabel.text = ""
                                    self.tipLabel.text = "Done!"
                                    
                                    UIView.animate(withDuration: 0.5, animations: {
                                        for item in self.view.subviews {
                                            item.alpha = 0
                                        }
                                    })
                                    print("[*] Finally init status: " + ret.description)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                                        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "tabbarVCEntry_StoryBoard_REG_ID")
                                        appDelegate.window?.rootViewController = initialViewController
                                        appDelegate.window?.makeKeyAndVisible()
                                    })
                                    
                                }
                                
                        } // initCheck_dpkg()
                } // refreshRepos()
        }) // initCheck()
    }
}



class tabbarVCEntry : UITabBarController {
    
}
