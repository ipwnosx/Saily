//
//  initViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import LTMorphingLabel

class initViewController: UIViewController, LTMorphingLabelDelegate {
    
    @IBOutlet weak var mainProgressBar: UIProgressView!
    @IBOutlet weak var tipLabel: LTMorphingLabel!
    @IBOutlet weak var tipSubLabel: LTMorphingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ret = returnStatusSuccess
        
        // May crash if you don't do this.
        DispatchQueue.main.async {
            self.tipLabel.delegate = self
            if (shouldAppDisableEffect) {
                self.tipLabel.morphingEnabled = false
                self.tipSubLabel.morphingEnabled = false
            }else{
                self.tipLabel.morphingEnabled = true
                self.tipSubLabel.morphingEnabled = true
            }
            self.tipLabel.morphingEffect = .scale
            self.tipSubLabel.morphingEffect = .scale
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute:
        {
            UIView.animate(withDuration: 0.1, animations: {
                self.mainProgressBar.progress = 0.1
            })
            ret = initCheck()
            
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "tabbarVCEntry")
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
