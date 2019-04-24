//
//  Navigators.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
import UIKit

class initTabBarContoller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let button = item.value(forKey: "_view") as? UIView ?? UIView()
        for item in button.subviews {
            if let image = item as? UIImageView {
                image.shineAnimation()
                break
            }
        }
    }
}

class main_tab_bar: UITabBar {
    var cleanDone = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.deleteUnusedViews()
    }
    
    func deleteUnusedViews() {
        if !self.cleanDone {
            var removeCount = 0
            for (_, eachView) in (self.subviews.enumerated()) {
                if NSStringFromClass(eachView.classForCoder).range(of: "_UITabBarBackgroundView") != nil {
                    eachView.removeFromSuperview()
                    removeCount += 1
                }
                if NSStringFromClass(eachView.classForCoder).range(of: "UIImageView") != nil {
                    eachView.removeFromSuperview()
                    removeCount += 1
                }
                if removeCount == 2 {
                    self.cleanDone = true
                    break
                }
            }
        }
    }
}
