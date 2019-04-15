//
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import Alamofire
import LTMorphingLabel

class saily_UI_init_view_controller: UIViewController, LTMorphingLabelDelegate {
    
    @IBOutlet weak var tipLabel: LTMorphingLabel!
    @IBOutlet weak var tipSubLabel: LTMorphingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (GVAR_behave_should_run_setup) {
            UIView.animate(withDuration: 0.5) {
                for i in self.view.subviews {
                    i.alpha = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "saily_UI_welcome_view_controller_ID")
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
                return 
            }
            return
        }
        
        tipLabel.text = GVAR_device_info_identifier_human_readable + " - " + GVAR_device_info_identifier + " - " + GVAR_device_info_current_version
        if (GVAR_device_info_UDID == "") {
            tipSubLabel.text = ""
        }else{
            tipSubLabel.text = GVAR_device_info_UDID.dropLast(10) + "**********"
        }
        
        // 质询Daemon检查是否在线
        // 提交沙箱路径，工作路径，队列路径
        // 质询Daemon检查Cydia或Sileo是否在线，可能退出
        // 准备Daemon检查dpkg是否存在错误
        
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "saily_UI_tabbar_init_er_ID")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
}

class saily_UI_tabbar_init_er : UITabBarController {
    
}
