//
//  UDIDViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import Swifter

var UDIDProfileIsQuerying = false

class UDIDViewController: UIViewController {
    
    @IBOutlet weak var leftC: NSLayoutConstraint!
    @IBOutlet weak var contentOfInfo: UIScrollView!
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for item in self.view.subviews {
            item.alpha = 0
        }
        self.contentOfInfo.isDirectionalLockEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if (UIScreen.main.bounds.width > 350) {
                self.leftC.constant = 25
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    for item in self.view.subviews {
                        item.alpha = 1
                    }
                })
            }
            self.contentOfInfo.contentOffset.x = 0 // <--- Why it doesn't work?
        }
    }
    
    @IBAction func skipUDID(_ sender: Any) {
        
    }
    
    @IBAction func readUDID(_ sender: Any) {
        
    }
    

    
}
