//
//  AppDelegate.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Saily.apart_init()
        
        
        // Design Level Build
        let ins1 = discover_C()
        let ins2 = discover_C()
        let ins3 = discover_C()
        
        ins1.apart_init(withString: "|标题|原网页链接|卡片标题|卡片副标题|卡片描述|卡片背景|1|卡片标题|卡片副标题|卡片描述|英文网页链接|是否有插件推荐|插件id|插件默认源地址|")
        ins2.apart_init(withString: "|越獄之父Saurik 拒絕替A12 設備更新 Cydia Substrate ，要大家忘記Cydia|https://mrmad.com.tw/saurik-not-update-cydia-substrate-for-a12-devices|Cydia将有可能成为历史|没有了Cydia世界会怎样？|幾個小時前， Saurik 在自己推特上發言，認為越獄已經在 iOS 9 時期就已經死亡，現在他不會想替 A12 設備更新，也沒理由免費解決這問題，最後他也要求大家忘記 Cydia ，似乎也暗示他決定要離開越獄圈。|https://mrmad.com.tw/wp-content/uploads/2019/04/jay-freeman-cydia-le-jailbreak-est-mort.jpg|2|Saurik Refused to Update Substrate for A12|Cydia is Now in History|What would the world be like without Cydia? Several hours before, the father of jailberak, Saurik twitted that jailbreak should not even shown after iOS 9. What's more?|some description|a/link.to/english/version|false|nil|nil|")
        ins3.apart_init(withString: "|NAN TEST|")
        
        Saily.discover_root = [ins2, ins1, ins3]
        
        
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = #colorLiteral(red: 0.2880531251, green: 0.5978398919, blue: 0.9421789646, alpha: 1)
        self.window!.makeKeyAndVisible()
        
        // rootViewController from StoryBoard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "Saily_UI_Tabbar_INIT_ID")
        self.window!.rootViewController = navigationController
        
        // logo mask
        navigationController.view.layer.mask = CALayer()
        navigationController.view.layer.mask?.contents = UIImage(named: "iConWhiteTransparent.png")!.cgImage
        navigationController.view.layer.mask?.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        navigationController.view.layer.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        navigationController.view.layer.mask?.position = CGPoint(x: navigationController.view.frame.width / 2, y: navigationController.view.frame.height / 2)
        
        // logo mask background view
        let maskBgView = UIView(frame: navigationController.view.frame)
        maskBgView.backgroundColor = UIColor.white
        navigationController.view.addSubview(maskBgView)
        navigationController.view.bringSubviewToFront(maskBgView)
        
        // logo mask animation
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self as? CAAnimationDelegate
        transformAnimation.duration = 1
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue.init(cgRect: (navigationController.view.layer.mask?.bounds)!)
        let secondBounds = NSValue.init(cgRect: CGRect(x: 0, y: 0, width: 75, height: 75))
        let finalBounds = NSValue.init(cgRect:CGRect(x: 0, y: 0, width: 3333, height: 3333))
        transformAnimation.values = [initalBounds, secondBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.5, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = CAMediaTimingFillMode.forwards
        navigationController.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
        
        // logo mask background view animation
        UIView.animate(withDuration: 0.1,
                       delay: 1.35,
                       options: .curveEaseIn,
                       animations: {
                        maskBgView.alpha = 0.0
        },
                       completion: { finished in
                        maskBgView.removeFromSuperview()
        })
        
        // root view animation
        UIView.animate(withDuration: 0.25,
                       delay: 1.3,
                       options: [],
                       animations: {
                        self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
                       completion: { finished in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.0,
                                       options: .curveEaseInOut,
                                       animations: {
                                        self.window!.rootViewController!.view.transform = .identity
                        },
                                       completion: nil
                        )
        })
        
        Saily.operation_quene.repo_queue.async {
            Saily.repos_root.refresh_call()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Saily.test_copy_board()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

