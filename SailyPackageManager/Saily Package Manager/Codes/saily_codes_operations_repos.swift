//
//  saily_codes_operations_repos.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/16.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import Foundation

import MKRingProgressView

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
    public var Pre_Depends             = [String]()
    public var Priority                = String()
    public var Section                 = String()
    public var SHA1                    = String()
    public var SHA256                  = String()
    public var Size                    = String()
    public var Tag                     = String()
    public var Version                 = String()
    
    public var unkown                  = [String : String]()

    func removeAll() -> Void {
        Author                  = ""
        Architecture            = ""
        Conflicts.removeAll()
        Depends.removeAll()
        Depiction               = ""
        Description             = ""
        Dev                     = ""
        Homepage                = ""
        Filename                = ""
        Installed_Size          = ""
        Maintainer              = ""
        MD5sum                  = ""
        Name                    = ""
        Package                 = ""
        Pre_Depends.removeAll()
        Priority                = ""
        Section                 = ""
        SHA1                    = ""
        SHA256                  = ""
        Size                    = ""
        Tag                     = ""
        Version                 = ""
    }
    
    func lookinit(what2: String, what_have: String) -> Int {
        switch what2.uppercased() {
        case "Author".uppercased():
            if (self.Author != "") {
                return -1
            }
            self.Author = what_have
        case "Architecture".uppercased():
            if (self.Architecture != "") {
                return -1
            }
            self.Architecture = what_have
        case "Conflicts".uppercased():
            if (self.Conflicts.count != 0) {
                return -1
            }
            for item in what_have.split(separator: ",") {
                var i = item.description
                inner: while (i.hasPrefix(" ")) {
                    i = i.dropFirst().description
                    if (i == "") {
                        break inner
                    }
                }
                inner: while (item.hasSuffix(" ")) {
                    i = i.dropLast().description
                    if (i == "") {
                        break inner
                    }
                }
                self.Conflicts.append(i)
            }
        case "Depends".uppercased():
            if (self.Depends.count != 0) {
                return -1
            }
            for item in what_have.split(separator: ",") {
                var i = item.description
                inner: while (i.hasPrefix(" ")) {
                    i = i.dropFirst().description
                    if (i == "") {
                        break inner
                    }
                }
                inner: while (item.hasSuffix(" ")) {
                    i = i.dropLast().description
                    if (i == "") {
                        break inner
                    }
                }
                self.Depends.append(i)
            }
        case "Depiction".uppercased():
            if (self.Depiction != "") {
                return -1
            }
            self.Depiction = what_have
        case "Description".uppercased():
            if (self.Description != "") {
                return -1
            }
            self.Description = what_have
        case "Dev".uppercased():
            if (self.Dev != "") {
                return -1
            }
            self.Dev = what_have
        case "Homepage".uppercased():
            if (self.Homepage != "") {
                return -1
            }
            self.Homepage = what_have
        case "Filename".uppercased():
            if (self.Filename != "") {
                return -1
            }
            self.Filename = what_have
        case "Installed-Size".uppercased():
            if (self.Installed_Size != "") {
                return -1
            }
            self.Installed_Size = what_have
        case "Maintainer".uppercased():
            if (self.Maintainer != "") {
                return -1
            }
            self.Maintainer = what_have
        case "MD5sum".uppercased():
            if (self.MD5sum != "") {
                return -1
            }
            self.MD5sum = what_have
        case "Name".uppercased():
            if (self.Name != "") {
                return -1
            }
            self.Name = what_have
        case "Package".uppercased():
            if (self.Package != "") {
                return -1
            }
            self.Package = what_have
        case "Pre-Depends".uppercased():
            if (self.Pre_Depends.count != 0) {
                return -1
            }
            for item in what_have.split(separator: ",") {
                var i = item.description
                inner: while (i.hasPrefix(" ")) {
                    i = i.dropFirst().description
                    if (i == "") {
                        break inner
                    }
                }
                inner: while (item.hasSuffix(" ")) {
                    i = i.dropLast().description
                    if (i == "") {
                        break inner
                    }
                }
                self.Pre_Depends.append(i)
            }
        case "Priority".uppercased():
            if (self.Priority != "") {
                return -1
            }
            self.Priority = what_have
        case "Section".uppercased():
            if (self.Section != "") {
                return -1
            }
            self.Section = what_have
        case "SHA1".uppercased():
            if (self.SHA1 != "") {
                return -1
            }
            self.SHA1 = what_have
        case "SHA256".uppercased():
            if (self.SHA256 != "") {
                return -1
            }
            self.SHA256 = what_have
        case "Size".uppercased():
            if (self.Size != "") {
                return -1
            }
            self.Size = what_have
        case "Version".uppercased():
            if (self.Version != "") {
                return -1
            }
            self.Version = what_have
        case "Tag".uppercased():
            if (self.Tag != "") {
                return -1
            }
            self.Tag = what_have
        default:
            self.unkown[what2] = what_have
        }
        return 0
    }

}

class repo_section_ins {
    public var name = String()
    public var packages = [repo_package]()

    init(name: String) {
        self.name = name
    }
    
}

class repo {
    public var name                                 = String()
    public var links                                = repo_link()           // major link must end with "/"
    public var icon_img                             = #imageLiteral(resourceName: "iConRound.png")
    public var sections                             = [repo_section_ins]()
    public var section_data_raw_string              = String()
    public var sections_data_source_path            = String()
    public var progress_view                        = RingProgressView()
    public var progress_view_should_show            = false
    public var operation_status = rts_repo_refresh_code_READY
    
    init() {
        print("[E] ERROR INIT REPO")
        abort()
    }
    
    init(major_link: String) {
        
        self.async_update_progress(progress: 0.1)
        
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
                    self.progress_view_should_show = false
                    self.async_update_progress(progress: 0)
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
    
    private var in_sort = false
    func sort_sections() -> Void {
        if (self.in_sort == true) {
            return
        }
        in_sort = true
        var str_sec_list = [String]()
        for item in self.sections {
            str_sec_list.append(item.name)
        }
        str_sec_list.sort()
        let last_sections = self.sections
        self.sections.removeAll()
        for item in str_sec_list {
            self.sections.append(self.return_section_with(name: item, and_sections: last_sections)!)
        }
    }
    
    func async_update_progress(progress: Double) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.38, animations: {
                self.progress_view.progress = progress
                if (self.progress_view_should_show == true) {
                    self.progress_view.alpha = 1
                }else{
                    self.progress_view.alpha = 0
                }
            })
        }
    }

    func refresh() -> Void {
        if (self.operation_status != rts_repo_refresh_code_READY) {
            return
        }
        self.progress_view_should_show = true
        self.async_update_progress(progress: 0.2)
        self.operation_status = rts_repo_refresh_code_START_DOWNLOAD
        sco_Network_download_release_from_link(repo: self) { (file_path) in
            self.async_update_progress(progress: 0.3)
            if (file_path == "ERROR DOWNLOAD") {
                self.operation_status = rts_repo_refresh_code_READY
                print("[E] Failed to download at :" + self.links.release)
                self.progress_view_should_show = false
                self.async_update_progress(progress: 0.0)
                return
            }
            self.operation_status = rts_repo_refresh_code_FINISH_DOWNLOAD
            print("[*] download of release successfully at: " + file_path)
            sco_File_decompress(file_path: file_path, completionHandler: { (ret) in
                self.async_update_progress(progress: 0.4)
                let read_deced = (try? String.init(contentsOfFile: file_path + ".out")) ?? ""
                if (ret == rts_EPERMIT) {
                    print("[E] Failed to decompress file at: " + file_path)
                    self.operation_status = rts_repo_refresh_code_READY
                    self.progress_view_should_show = false
                    self.async_update_progress(progress: 0.0)
                    if (read_deced == "") {
                        return
                    }else{
                        print("[*] Using file to init sections even there is an error at: " + file_path + ".out")
                        self.progress_view_should_show = true
                        self.async_update_progress(progress: 0.45)
                    }
                }else{
                    print("[*] Using file to init sections at: " + file_path + ".out")
                }
                self.sections_data_source_path = file_path + ".out"
                self.init_repo_section(release_file_path: self.sections_data_source_path, completionHandler: {
                    self.async_update_progress(progress: 0.888)
                    self.operation_status = rts_repo_refresh_code_FINISH_DATABASE
                    self.sort_sections()
                    
                    // Finish init sections.
                    self.async_update_progress(progress: 1.0)
                    self.operation_status = rts_repo_refresh_code_READY
                    self.progress_view_should_show = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.async_update_progress(progress: 1.0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.async_update_progress(progress: 0.0)
                        }
                    }
                    return
                })
            })
        }
    }
    
    private func init_repo_section(release_file_path: String, completionHandler: @escaping () -> ()) -> Void {
        self.async_update_progress(progress: 0.666)
        self.operation_status = rts_repo_refresh_code_START_DATABASE
        self.section_data_raw_string = ""
        
        var temp_read_data = try? String.init(contentsOfFile: self.sections_data_source_path)
        if (temp_read_data == nil) {
            let ascii_data = try? Data.init(contentsOf: URL.init(fileURLWithPath: self.sections_data_source_path))
            if (ascii_data != nil) {
                temp_read_data = String.init(data: ascii_data!, encoding: .ascii)
            }
        }
        
        if (temp_read_data != nil) {
            self.section_data_raw_string = temp_read_data!
        }else{
            print("[E] Error reading database at :" + release_file_path)
            self.progress_view_should_show = false
            self.async_update_progress(progress: 0.0)
            return
        }
        
        let tmp_package = repo_package()
        for item in self.section_data_raw_string.split(separator: "\n") {
            if (item.split(separator: ":")[0].count < 2 || !item.description.contains(": ")) {
//                print("[E] Error package info: " + item.description)
            }else{
//                // print("[*] Package info: " + item.description)
                var package_info_head = item.split(separator: ":")[0].description
                var package_info_body = item.split(separator: ":")[1].description
                while (package_info_head.hasPrefix(" ")) {
                    package_info_head = package_info_head.dropFirst().description
                }
                while (package_info_head.hasSuffix(" ")) {
                    package_info_head = package_info_head.dropLast().description
                }
                while (package_info_body.hasPrefix(" ")) {
                    package_info_body = package_info_body.dropFirst().description
                }
                while (package_info_body.hasSuffix(" ")) {
                    package_info_body = package_info_body.dropLast().description
                }
                if (tmp_package.lookinit(what2: package_info_head, what_have: package_info_body) == 0) {
                    // go on.
                }else{
                    // Next Package
                    let tr = tmp_package
                    if let section = return_section_with(name: tr.Section, and_sections: self.sections) {
                        section.packages.append(tr)
                    }else{
                        sections.append(repo_section_ins.init(name: tr.Section))
                        let s = return_section_with(name: tr.Section, and_sections: self.sections)!
                        s.packages.append(tr)
                    }
//                    // print("[*] Done package: " + tr.Package)
                    tmp_package.removeAll()
                    _ = tmp_package.lookinit(what2: package_info_head, what_have: package_info_body)
                }
            }
        }
        
        // The last one.
        if (tmp_package.Package != "") {
            let tr = tmp_package
            if let section = return_section_with(name: tr.Section, and_sections: self.sections) {
                section.packages.append(tr)
            }else{
                sections.append(repo_section_ins.init(name: tr.Section))
                let s = return_section_with(name: tr.Section, and_sections: self.sections)!
                s.packages.append(tr)
            }
//            // print("[*] Done package: " + tr.Package)
        }

        completionHandler()
    }

    private func return_section_with(name: String, and_sections : [repo_section_ins]) -> repo_section_ins? {
        for item in and_sections {
                    if (name.uppercased() == item.name.uppercased()) {
                return item
            }
        }
        return nil
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
