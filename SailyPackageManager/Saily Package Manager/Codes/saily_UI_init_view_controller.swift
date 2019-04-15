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
        
    }
}



class tabbarVCEntry : UITabBarController {
    
}
