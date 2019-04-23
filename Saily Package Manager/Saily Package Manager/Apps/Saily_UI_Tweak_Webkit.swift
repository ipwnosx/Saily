//
//  Saily_UI_Tweak_Webkit.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/22.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

class Saily_UI_Tweak_Webkit: UIViewController {

    public var this_package: packages_C? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("[*] Catch package info:")
        print(self.this_package?.info as Any)
        
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


