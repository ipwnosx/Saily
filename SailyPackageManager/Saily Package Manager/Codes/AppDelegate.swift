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
        
        GVAR_behave_app_root_file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        GVAR_behave_repo_list_file_path = GVAR_behave_app_root_file_path + "/repo.list"
        GVAR_behave_job_quene_submit_path = GVAR_behave_app_root_file_path + "/quene.submit"
        GVAR_behave_udid_path = GVAR_behave_app_root_file_path + "/ud.id"
        
        sco_File_make_sure_file_at(path: GVAR_behave_repo_list_file_path, isDirect: false)
        sco_File_make_sure_file_at(path: GVAR_behave_job_quene_submit_path, isDirect: true)
        
        let repo_raw_read = (try? String.init(contentsOfFile: GVAR_behave_repo_list_file_path)) ?? ""
        for item in repo_raw_read.split(separator: "\n") {
            GVAR_behave_repo_list_instance.append(item.description)
        }
        
        // Clean lock file
        sco_File_remove_any_lck_file_at_main_and_repo()
        
        // Init device info
        GVAR_device_info_identifier_human_readable = UIDevice.init_identifier_and_return_human_readable_string
        GVAR_device_info_current_version = UIDevice.current.systemVersion
        GVAR_device_info_UDID = (try? String.init(contentsOfFile: GVAR_behave_udid_path)) ?? "?"
        if (GVAR_device_info_UDID == "?" || GVAR_behave_repo_list_instance.count == 0) {
            GVAR_device_info_UDID = ""
            GVAR_behave_should_run_setup = true
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
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}


