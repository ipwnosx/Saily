//
//  AppDelegate.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import FLEX

var is_launch_time = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Crash Dang! 嗯哼~ Check file ~~~/GitHub/SailyPackageManager/SailyPackageManager/AUTH_ENCODE_NONE.swift
        // The heart of saily is a launch daemon, and the authorization wich is highly protected by close the source.
        // Yes, I know, you can do a RE to decrypt it, but, if you just want to build and run or have your own code, do it yourself.
        _ = AUTH_Encode(readin: " ")
        
        const_objc_bridge_object.redirectConsoleLogToDocumentFolder()
        
        GVAR_behave_app_root_file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        GVAR_behave_repo_list_file_path = GVAR_behave_app_root_file_path + "/repo.list"
        GVAR_behave_repo_icon_cache_folder_path = GVAR_behave_app_root_file_path + "/repo.icon.cache"
        GVAR_behave_repo_info_cache_folder_path = GVAR_behave_app_root_file_path + "/repo.info.cache"
        GVAR_behave_job_quene_submit_path = GVAR_behave_app_root_file_path + "/quene.submit"
        GVAR_behave_udid_path = GVAR_behave_app_root_file_path + "/ud.id"
        
        sco_File_make_sure_file_at(path: GVAR_behave_repo_list_file_path, isDirect: false)
        sco_File_make_sure_file_at(path: GVAR_behave_job_quene_submit_path, isDirect: true)
        sco_File_make_sure_file_at(path: GVAR_behave_repo_icon_cache_folder_path, isDirect: true)
        sco_File_make_sure_file_at(path: GVAR_behave_repo_info_cache_folder_path, isDirect: true)
        
        if let cache_files = try? FileManager.default.contentsOfDirectory(atPath: GVAR_behave_repo_info_cache_folder_path) {
            for item in cache_files {
                if (item.hasSuffix(".link") || item.hasSuffix(".info")) {
                    let read = try? String.init(contentsOfFile: item)
                    if (read == nil || read == "") {
                        try? FileManager.default.removeItem(atPath: item)
                    }
                }
            }
        }
        
        sco_repos_read_repos_from_file_at_delegate()
        
        // Init device info
        GVAR_device_info_identifier_human_readable = UIDevice.init_identifier_and_return_human_readable_string
        GVAR_device_info_current_version = UIDevice.current.systemVersion
        GVAR_device_info_UDID = (try? String.init(contentsOfFile: GVAR_behave_udid_path)) ?? "?"
        if (GVAR_device_info_UDID == "?") {
            GVAR_device_info_UDID = ""
            GVAR_behave_should_run_setup = true
        } // do these two if separately
        
        // Clean lock file
        sco_File_remove_any_lck_file_at_main_and_repo()
        
        // Configurations of url session.
                            // Example:
                            //        GET /igg/./CydiaIcon.png HTTP/1.1
                            //        Host: aquawu.github.io
                            //        If-None-Match: "5c7bd7d7-aaaaa"
                            //        Accept: */*
                            //        If-Modified-Since: Sun, 03 Mar 2019 13:34:15 GMT
                            //        User-Agent: Cydia/0.9 CFNetwork/974.2.1 Darwin/18.0.0
                            //        Accept-Language: zh-cn
                            //        Accept-Encoding: gzip, deflate
                            //        Connection: keep-alive
                            // If-Modified-Since, Always require new data.
//
//        UIApplication.shared.setMinimumBackgroundFetchInterval(
//            UIApplication.backgroundFetchIntervalMinimum)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        sco_repos_resave_repos_list()
        if (GVAR_device_info_UDID == "") {

        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if (is_launch_time) {
            is_launch_time = false
            return
        }
        if (GVAR_behave_repo_instance.count == 0 || GVAR_device_info_UDID == "") {
            let repo_raw_read = (try? String.init(contentsOfFile: GVAR_behave_repo_list_file_path)) ?? ""
            for item in repo_raw_read.split(separator: "\n") {
                GVAR_behave_repo_instance.append(repo(major_link: item.description))
            }
            GVAR_device_info_UDID = (try? String.init(contentsOfFile: GVAR_behave_udid_path)) ?? "?"
            if (GVAR_device_info_UDID == "?") {
                GVAR_device_info_UDID = ""
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
                    let initialViewController = topController.storyboard!.instantiateViewController(withIdentifier: "saily_UI_init_view_controller_ID")
                    appDelegate.window?.rootViewController = initialViewController
                    appDelegate.window?.makeKeyAndVisible()
                }
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}
