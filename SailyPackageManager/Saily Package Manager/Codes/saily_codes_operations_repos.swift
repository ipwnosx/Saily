//
//  saily_codes_operations_repos.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/16.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import Foundation

class repo_link {
    public var major   = String()
    public var icon    = String()
    public var release = String()
}

class repo_package {
//    Package: abgrouper
//    Version: 0.3
//    Section: Utilities
//    Maintainer: Spektro <support@iblacklist.com.br>
//    Architecture: iphoneos-arm
//    Filename: debs2.0/abgrouper_0.3.deb
//    Size: 315648
//    MD5sum: 7616d2567e1c0fa642f4da4529d4ad60
//    Name: ABGrouper
//    Description: Create, Manage and Delete GROUPS of contacts in your AddressBook. Additionally, it ables you to export Groups of contacts as lists for iBlacklist software and backup/restore iBlacklist database. A new section will appear if you have iBlacklist installed on your device.
//    Author: Spektro <support@iblacklist.com.br>
//    Depiction: http://moreinfo.thebigboss.org/moreinfo/abgrouperDp.php
//    homepage: http://moreinfo.thebigboss.org/moreinfo/abgrouper.php
//    dev: alexandre
    public var depiction_raw           = String()
    
    public var Author                  = String()
    public var Architecture            = String()
    public var Conflicts               = [String]()
    public var Depends                 = [String]()
    public var Depiction               = String()
    public var Description             = String()
    public var Dev                     = String()
    public var Homepage                = String()
    public var Filename                = String()
    public var Installed_Size          = String()
    public var Maintainer              = String()
    public var MD5sum                  = String()
    public var Name                    = String()
    public var Package                 = String()
    public var Section                 = String()
    public var SHA1                    = String()
    public var Size                    = String()
    public var Version                 = String()
}

class repo_sections {
    public var name = String()
    public var packages = [repo_package]()
}

class repo {
    public var name                                 = String()
    public var links                                = repo_link()           // major link must end with "/"
    public var icon_img                             = #imageLiteral(resourceName: "iConRound.png")
    public var sections                             = [repo_sections]()
    public var sections_data_source_path            = String()
    public var progress                             = Double.init(exactly: 0.0)!
    public var operation_status = rts_repo_refresh_code_READY
    
    init() {
        print("[*] ERROR INIT REPO")
        abort()
    }
    
    init(major_link: String) {
        
        self.progress = 0.1
        
        if (major_link == "com.Saily.testInit" || major_link == "") {
            return
        }
        
        self.name = sco_repos_link_to_name(link: major_link)
        self.links.major = major_link
        self.links.icon = major_link + "CydiaIcon.png"
        
        let release_cache_file_path = GVAR_behave_repo_info_cache_folder_path + "/" + self.name + ".info.release.link"
        sco_File_make_sure_file_at(path: release_cache_file_path, isDirect: false)
        
        GCD_repo_operations_init_quene.async {
            sco_Network_return_CydiaIcon(repo: self, force_refetch: false, completionHandler: { (img) in
                self.icon_img = img
            })
        }
        GCD_repo_operations_init_quene.async {
            sco_Network_search_for_packages_and_return_release_link(repo: self, completionHandler: { (str) in
                if (str == "ERROR_SEARCHING_RELEASE_PACKAGES") {
                    self.progress = 0
                    self.operation_status = rts_repo_refresh_code_READY
                    return
                }
                self.links.release = str
                try? str.write(toFile: release_cache_file_path, atomically: true, encoding: .utf8)
                // sections
                GCD_repo_operations_quene.async {
                    self.refresh()
                }
            })
        }
    }
    
    func refresh() -> Void {
        if (self.operation_status != rts_repo_refresh_code_READY) {
            return
        }
        self.progress = 0.2
        self.operation_status = rts_repo_refresh_code_START_DOWNLOAD
        sco_Network_download_release_from_link(repo: self) { (file_path) in
            self.progress = 0.3
            if (file_path == "ERROR DOWNLOAD") {
                self.operation_status = rts_repo_refresh_code_READY
                print("[E] Failed to download at :" + self.links.release)
                self.progress = 0.0
                return
            }
            self.operation_status = rts_repo_refresh_code_FINISH_DOWNLOAD
            print("[*] download of release successfully at: " + file_path)
            sco_File_decompress(file_path: file_path, completionHandler: { (ret) in
                self.progress = 0.4
                let read_deced = (try? String.init(contentsOfFile: file_path + ".out")) ?? ""
                if (ret == rts_EPERMIT) {
                    print("[E] Failed to decompress file at: " + file_path)
                    self.operation_status = rts_repo_refresh_code_READY
                    self.progress = 0.0
                    if (read_deced == "") {
                        return
                    }
                }else{
                    print("[*] Using file to init sections at: " + file_path + ".out")
                }
                self.sections_data_source_path = file_path + ".out"
                self.init_repo_section(release_file_path: self.sections_data_source_path, completionHandler: {
                    self.progress = 0.888
                    self.operation_status = rts_repo_refresh_code_FINISH_DATABASE
                    
                    
                    self.progress = 1
                    self.operation_status = rts_repo_refresh_code_READY
                    return
                })
            })
        }
    }
    
    private func init_repo_section(release_file_path: String, completionHandler: @escaping () -> ()) -> Void {
        self.progress = 0.666
        self.operation_status = rts_repo_refresh_code_START_DATABASE
        
        completionHandler()
    }
    

    
}

func sco_repos_read_repos_from_file_at_delegate() -> () {
    let repo_raw_read = (try? String.init(contentsOfFile: GVAR_behave_repo_list_file_path)) ?? ""
    for item in repo_raw_read.split(separator: "\n") {
        GVAR_behave_repo_instance.append(repo(major_link: item.description))
    }
    if (GVAR_behave_repo_instance.count == 0) {
        let default_repos = ["http://apt.thebigboss.org/repofiles/cydia/",
                             "http://build.frida.re/",
                             "https://apt.bingner.com/",
                             "https://repo.chariz.io/",
                             "https://repo.dynastic.co/",
                             "https://sparkdev.me/",
                             "https://repo.nepeta.me/"]
        for item in default_repos {
            GVAR_behave_repo_instance.append(repo(major_link: item.description))
        }
    }
}

func sco_repos_link_to_name(link: String) -> String {
    var name = link.split(separator: "/")[1].description
    if (name.split(separator: ".").count == 2) {
        name = name.split(separator: ".")[0].description
    }else{
        if (name.split(separator: ".")[0] == "apt" || name.split(separator: ".")[0] == "repo" || name.split(separator: ".")[0] == "cydia") {
            name = name.split(separator: ".")[1].description
        }
    }
    
    name = name.first!.description.uppercased() + name.dropFirst().description
    if (name == "Thebigboss") {
        name = "The Big Boss"
    }
    
    return name
}

func sco_repos_resave_repos_list() -> Void {
    var out = ""
    for repo in GVAR_behave_repo_instance {
        print("[*] Saving repo: " + repo.links.major)
        out = out + repo.links.major + "\n"
    }
    try? FileManager.default.removeItem(atPath: GVAR_behave_repo_list_file_path)
    try? out.write(toFile: GVAR_behave_repo_list_file_path, atomically: true, encoding: .utf8)
}

// refresh is triggered by pull to refresh
