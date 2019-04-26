//
//  RootClass.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import LTMorphingLabel
import MKRingProgressView

let status_ins = status_class()

class status_class {
    public var ready        = 00
    public var in_operation = 01
    public var in_wrapper   = 02
    public var ret_success  = 06
    public var ret_failed   = -1
}

let Saily = Saily_All()

class Saily_All {
    // This session, contains gobal variable that is fixed during build time.
    public let is_debug                                         = true
    public let operation_quene                                  = Saily_operayions_quene()
    // This session, contains gobal settings or memory container struct
    public var is_Chinese                                       = false
    public var is_jailbroken                                    = false
    public var files                                            = Saily_file_system()
    public var device                                           = Saily_device_info()
    // This session, RAM data section
    public var repos_root                                       = repo_C()
    public var root_packages                                    = [packages_C]()
    public var root_packages_in_build                           = String()
    public var root_packages_bad_build                          = false
    public var discover_root                                    = [discover_C]()
    public var discover_raw_str                                 = String()
    public var discover_image_cache                             = [String : UIImage] ()
    public var operation_container                              = installer_Unit()
    // Obj-C bridge
    public var objc_bridge                                      = SailyCommonObject()
    // Magic:
    public var copy_board                                       = String()
    public var copy_board_can_use                               = false
    public var daemon_online                                    = false
    // One More ThingS
    public var app_web_site                                     = "https://twitter.com/TrySaily"
    public var searched_packages                                = [String : packages_C]()
    
    func apart_init() {
        
        self.objc_bridge.redirectConsoleLogToDocumentFolder()
        
        let locale = NSLocale.preferredLanguages
        print(locale)
        
        if (((locale.first?.split(separator: "-").first ?? "") == "zh") || locale.first?.uppercased().contains("TW") ?? false) {
            self.is_Chinese = true
            self.app_web_site = "https://lakraream.wixsite.com/saily/"
        }
        
//        for item in locale {
//            if (item.contains("zh") || item.contains("CN")) {
//                self.is_Chinese = true
//                break
//            }
//        }
        
        // apart_init_anything_required!
        self.files.apart_init()
        self.device.apart_init()
        CydiaNetwork.apart_init(udid: self.device.udid, firmare: self.device.version, machine: self.device.identifier)
        
        // Download today.
//        Saily.operation_quene.network_queue.async {
//            AF.download(URL.init(string: "https://raw.githubusercontent.com/Co2333/SailyHomePagePreview/master/preview")!).responseString(completionHandler: { (respond) in
//                self.discover_raw_str = respond.value ?? ""
//                self.reload_discover()
//            })
//        }
        
        self.discover_raw_str = (try? String.init(contentsOf: URL.init(string: "https://raw.githubusercontent.com/Co2333/SailyHomePagePreview/master/preview")!)) ?? ""
        let discover_raw_str_split = self.discover_raw_str.split(separator: "◊")
        
        if (discover_raw_str_split.count >= 2) {
            if (self.is_Chinese) {
                self.discover_raw_str = String(discover_raw_str_split[1])
            }else{
                self.discover_raw_str = String(discover_raw_str_split[0])
            }
        }else if (discover_raw_str_split.count == 1){
            self.discover_raw_str = String(discover_raw_str_split[0])
        }else{
            print("[*] Error in loading discover.")
        }
        
        // init discover
        var items = self.discover_raw_str.split(separator: "\n")
        
        if (items.count > 1) {
            items.remove(at: 0)
            for item in items {
                let dis = discover_C()
                dis.apart_init(withString: item.description)
                self.discover_root.append(dis)
            }
        }
        
        print("[*] Staring loading image cache...")
        for item in Saily.discover_root {
            let link_of_image = item.image_link
            if let name_of_image = item.image_link.split(separator: "/").last {
                let url0 = URL.init(fileURLWithPath: self.files.image_cache + "/" + name_of_image)
                if let data = try? Data.init(contentsOf: url0) {
                    if let image = UIImage.init(data: data) {
                        self.discover_image_cache[link_of_image] = image
                    }
                }
            }
        }

        
        // The last would be repos
        self.repos_root.apart_init()
        // detect jailbreak
        let jailbroken_signal = ["/private/var/stash",
                                 "/private/var/lib/apt",
                                 "/private/var/tmp/cydia.log",
                                 "/Library/MobileSubstrate/MobileSubstrate.dylib",
                                 "/var/cache/apt",
                                 "/var/lib/apt",
                                 "/var/lib/cydia",
                                 "/var/log/syslog",
                                 "/var/tmp/cydia.log",
                                 "/bin/bash",
                                 "/bin/sh",
                                 "/usr/sbin/sshd",
                                 "/usr/libexec/ssh-keysign",
                                 "/usr/sbin/sshd",
                                 "/usr/bin/sshd",
                                 "/usr/libexec/sftp-server",
                                 "/etc/ssh/sshd_config",
                                 "/etc/apt",
                                 "/Applications/Cydia.app",
                                 "/Applications/Sileo.app",
                                 "/Applications/Saily Package Manager.app"]
        for item in jailbroken_signal {
            if (FileManager.default.fileExists(atPath: item)) {
                self.is_jailbroken = true
                break
            }
        }
        
    }
    
    func rebuild_All_My_Packages() {
        let s = DispatchSemaphore(value: 0)
        var can_do_it = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for repo in self.repos_root.repos {
                if (repo.exposed_progress_view.progress != 1.0 && repo.exposed_progress_view.progress != 0.0) {
                    can_do_it = false
                    break
                }
            }
            s.signal()
        }
        s.wait()
        if (!can_do_it) {
            return
        }
        if (self.root_packages_in_build != "") {
            return
        }
        let session_token = UUID().uuidString
        self.root_packages_in_build = session_token
        self.root_packages = [packages_C]() // Do not use removeAll it crashes.
        self.operation_quene.repo_queue.async {
            print("[*] Triggered rebuild master packages.")
            for repo in self.repos_root.repos {
                for section in repo.section_root {
                    for package in section.packages {
                        if (self.root_packages_in_build != session_token) {
                            self.root_packages_bad_build = true
                            return
                        }
                        self.root_packages.append(package)
                    }
                }
            }
            print("[*] Rebuild done.")
            self.root_packages_in_build = ""
            if (Saily.root_packages_bad_build) {
                print("[*] Bad rebuild.")
                self.root_packages_bad_build = false
                self.operation_quene.repo_queue.asyncAfter(deadline: .now() + 2) {
                    Saily.rebuild_All_My_Packages()
                }
            }
        }
    }
    
    func test_copy_board() {
        if let str = UIPasteboard.general.string {
            if (str == "") {
                return
            }
            if (!str.hasPrefix("http")) {
                let str1 = "http://" + str
                let str2 = "https://" + str
                guard URL.init(string: str1) != nil else {
                    return
                }
                guard URL.init(string: str2) != nil else {
                    return
                }
                Saily.operation_quene.network_queue.async {
                    let s = DispatchSemaphore(value: 0)
                    var rett = false
                    AFF.test_a_url(url: URL.init(string: str1)!, end_call: { (ret) in
                        rett = ret
                        s.signal()
                    })
                    s.wait()
                    if (rett) {
                        self.copy_board = str1
                        self.copy_board_can_use = true
                    }else{
                        let ss = DispatchSemaphore(value: 0)
                        AFF.test_a_url(url: URL.init(string: str2)!, end_call: { (ret) in
                            rett = ret
                            ss.signal()
                        })
                        ss.wait()
                        if (rett) {
                            self.copy_board = str2
                            self.copy_board_can_use = true
                        }else{
                            self.copy_board = ""
                            self.copy_board_can_use = false
                        }
                    }
                    return
                }
                return
            }else{
                if let url0 = URL.init(string: str) {
                    AFF.test_a_url(url: url0) { (ret) in
                        if (ret == true) {
                            self.copy_board = str
                            self.copy_board_can_use = true
                        }else{
                            self.copy_board = ""
                            self.copy_board_can_use = false
                        }
                    }
                }else{
                    self.copy_board = ""
                    self.copy_board_can_use = false
                }
            }
        }else{
            self.copy_board = ""
            self.copy_board_can_use = false
        }
    }
    
    func search_a_package_with(its_name: String) -> packages_C? {
        if let item = self.searched_packages[its_name] {
            return item
        }
        for item in self.root_packages {
            if (item.info["PACKAGE"] == its_name) {
                self.searched_packages[its_name] = item
                return item
            }
        }
        return nil
    }
    
}

// This session, contains sandboxed file paths
class Saily_file_system {
    public var root             = String()
    public var udid_true        = String()
    public var udid             = String()
    public var repo_list        = String()
    public var repo_list_signal = String()
    public var repo_cache       = String()
    public var queue_root       = String()
    public var daemon_root       = String()
    public var image_cache      = String()
    
    func apart_init() {
        self.root = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.udid = self.root + "/ud.id"
        self.udid_true = self.root + "/ud.id.true"
        self.repo_list = self.root + "/repo.list"
        self.repo_list_signal = self.root + "/repo.list.initd"
        self.repo_cache = self.root + "/repo.cache"
        self.queue_root = self.root + "/queue.submit"
        self.image_cache = self.root + "/image.cache"
        self.daemon_root = self.root + "/daemon.call"
        
        Saily_FileU.make_sure_file_exists_at(self.udid, is_direct: false)
        Saily_FileU.make_sure_file_exists_at(self.repo_list, is_direct: true)
        Saily_FileU.make_sure_file_exists_at(self.repo_cache, is_direct: true)
        Saily_FileU.make_sure_file_exists_at(self.queue_root, is_direct: true)
        Saily_FileU.make_sure_file_exists_at(self.image_cache, is_direct: true)
        Saily_FileU.make_sure_file_exists_at(self.daemon_root, is_direct: true)
        
        print("[*] File System Apart Init root = " + self.root)
        print("[*] File System Apart Init udid = " + self.udid)
        print("[*] File System Apart Init udid signal = " + self.udid_true)
        print("[*] File System Apart Init repo_list = " + self.repo_list)
        print("[*] File System Apart Init repo_list signal = " + self.repo_list_signal)
        print("[*] File System Apart Init queue_root = " + self.queue_root)
        print("[*] File System Apart Init image_cache = " + self.image_cache)
        print("[*] File System Apart Init image_cache = " + self.daemon_root)
        
        for item in self.daemon_root {
            try? FileManager.default.removeItem(atPath: item.description)
        }
        
    }
}

// This session, contains device info
class Saily_device_info {
    public var udid                             = String()
    public var udid_is_true                     = false
    public var version                          = String()
    public var identifier                       = String()
    public var indentifier_human_readable       = String()
    
    func apart_init() {
        // init UDID
        let udid_read = Saily_FileU.simple_read(Saily.files.udid)
        if (udid_read == nil || udid_read == "") {
            let str = UUID().uuidString
            var out = ""
            for item in str {
                if (item != "-") {
                    out += item.description
                }
            }
            out += UUID().uuidString.dropLast(28)
            out = out.lowercased()
            Saily_FileU.simple_write(file_path: Saily.files.udid, file_content: out)
            self.udid = Saily_FileU.simple_read(Saily.files.udid)!
        }else{
            self.udid = udid_read!
        }
        
        if (Saily_FileU.exists(file_path: Saily.files.udid_true)) {
            self.udid_is_true = true
        }else{
            self.udid_is_true = false
        }
        
        // anything else
        self.version = UIDevice.current.systemVersion
        self.indentifier_human_readable = UIDevice.init_identifier_and_return_human_readable_string
        
        print("[*] Device Info Apart Init udid = " + self.udid + " and is it true? " + self.udid_is_true.description)
        print("[*] Device Info Apart Init version = " + self.version)
        print("[*] Device Info Apart Init identifier = " + self.identifier)
        print("[*] Device Info Apart Init indentifier_human_readable = " + self.indentifier_human_readable)
    }
    
    
}

class Saily_operayions_quene {
    
    public let network_queue = DispatchQueue(label: "Saily.queue.netwoek",
                                             qos: .utility, attributes: .concurrent)
    public let repo_queue    = DispatchQueue(label: "Saily.queue.repo",
                                             qos: .utility, attributes: .concurrent)
    public let wrapper_queue = DispatchQueue(label: "Saily.queue.wrapper",
                                             qos: .utility, attributes: .concurrent)
    public let search_queue  = OperationQueue()
    
}

