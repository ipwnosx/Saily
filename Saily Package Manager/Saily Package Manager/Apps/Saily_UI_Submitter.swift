//
//  Saily_UI_Submitter.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/29.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

import LTMorphingLabel
import NVActivityIndicatorView

class Saily_UI_Submitter: UIViewController, LTMorphingLabelDelegate {
    
    @IBOutlet weak var title_install: LTMorphingLabel!
    
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_install.delegate = self
        
        let progress = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .circleStrokeSpin, color: .white, padding: nil)
        self.view.addSubview(progress)
        
        progress.snp.makeConstraints { (x) in
            x.left.equalTo(self.view.snp.left).offset(18)
            x.bottom.equalTo(self.view.snp.bottom).offset(-15)
            x.width.equalTo(18)
            x.height.equalTo(18)
        }
        progress.startAnimating()
        
        
    }
    


}
