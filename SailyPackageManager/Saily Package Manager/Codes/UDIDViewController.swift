//
//  UDIDViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit

class UDIDViewController: UIViewController {
    
    @IBOutlet weak var leftC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for item in self.view.subviews {
            item.alpha = 0
        }
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
        }
        
        
    }
    
    @IBAction func skipUDID(_ sender: Any) {
        var UDID = ""
        let alert = UIAlertController.init(title: "Are you sure?", message: "You would not be able to buy any tweak or download any tweak you have brought.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Okay", style: .cancel, handler: { (_) in
            for _ in 1...40 {
                UDID += Int.random(in: 0...9).description
            }
            print("[*] new rnd-UDID is: " + UDID)
            try? UDID.write(toFile: appRootFileSystem + "/ud.id", atomically: true, encoding: .utf8)
            if (!FileManager.default.fileExists(atPath: appRootFileSystem + "/ud.id")) {
                let alert = UIAlertController.init(title: "Error", message: "Error writing file.", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Exit.", style: .cancel, handler: { (_) in
                    exit(Int32(returnStatusEPERMIT))
                }))
                    self.present(alert, animated: true, completion: nil)
                return
            }
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "initViewController_StoryBoard_REG_ID")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func readUDID(_ sender: Any) {
        print(SailyBridgerOBJCObjectInitED.readUDID())
    }
    

}
