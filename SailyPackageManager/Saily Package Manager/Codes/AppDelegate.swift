//
//  AppDelegate.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import FLEX

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SailyBridgerOBJCObjectInitED.redirectConsoleLogToDocumentFolder()
        
        let homeDir = NSHomeDirectory()
        if (homeDir.contains("/Applications")) {
            SailyBridgerOBJCObjectInitED.setMyUID0()
        }
        
        if (isInDebugSession) {
            FLEXManager.shared().showExplorer()
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
        if (UDIDProfileIsQuerying) {
            if (FileManager.default.fileExists(atPath: appRootFileSystem + "/ud.id")) {
                deviceInfo_UDID = try! String.init(contentsOfFile: appRootFileSystem + "/ud.id")
            }
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                UIView.animate(withDuration: 0.5) {
                    for item in topController.view.subviews {
                        item.alpha = 0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                    let initialViewController = topController.storyboard!.instantiateViewController(withIdentifier: "initViewController_StoryBoard_REG_ID")
                    appDelegate.window?.rootViewController = initialViewController
                    appDelegate.window?.makeKeyAndVisible()
                }
            }
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

