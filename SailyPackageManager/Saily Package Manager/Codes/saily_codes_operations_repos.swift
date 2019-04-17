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
    public var main    = String()
    public var icon    = String()
    public var release = String()
}

class repo_sections {
    public var name = String()
    public var packages = [repo_package]()
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

class repo {
    public var name             = String()
    public var links            = repo_link()           // major link must end with "/"
    public var icon_img         = #imageLiteral(resourceName: "iConRound.png")
    public var sections         = [repo_sections]()
    
    init() {
        print("[*] ERROR INIT REPO")
        abort()
    }
    
    init(major_link: String) {
        self.name = sco_repos_link_to_name(link: major_link)
        self.links.main = major_link
        self.links.icon = major_link + "CydiaIcon.png"
        GCD_repo_operations_init_quene.async {
            sco_Network_return_CydiaIcon(link: major_link, force_refetch: false, completionHandler: { (img) in
                self.icon_img = img
            })
        }
        GCD_repo_operations_init_quene.async {
            sco_Network_search_for_packages_and_return_release_link(major_link: major_link, completionHandler: { (str) in
                self.links.release = str
            })
        }
        // sections
        
    }
    
    func refresh(completionHandler: @escaping () -> ()) -> Void {
        
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

func sco_repos_resave_repo_list() -> Void {
    var out = ""
    for repo in GVAR_behave_repo_instance {
        out = out + repo.links.main + "\n"
    }
    try? FileManager.default.removeItem(atPath: GVAR_behave_repo_list_file_path)
    try? out.write(toFile: GVAR_behave_repo_list_file_path, atomically: true, encoding: .utf8)
}

// refresh is triggered by pull to refresh
