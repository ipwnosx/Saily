//
//  RepoClass.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation

class repo_ins {
    public var repos        = [a_repo]()
    public var status       = status_ins.ready
    
    func apart_init() {
        if (Saily_FileU.exists(file_path: Saily.files.repo_list_signal)) {
            let read = Saily_FileU.simple_read(Saily.files.repo_list)
            for item in read?.split(separator: "\n") ?? [] {
                let repo = a_repo(ilink: item.description)
                self.repos.append(repo)
            }
        }else{
            let default_links = ["http://apt.thebigboss.org/repofiles/cydia/",
                                 "http://build.frida.re/",
                                 "https://apt.bingner.com/",
                                 "https://repo.chariz.io/",
                                 "https://repo.dynastic.co/",
                                 "https://sparkdev.me/",
                                 "https://repo.nepeta.me/"]
            var out = ""
            for item in default_links {
                let repo = a_repo(ilink: item.description)
                self.repos.append(repo)
                out = item.description + "\n"
            }
            Saily_FileU.simple_write(file_path: Saily.files.repo_list, file_content: out)
            Saily_FileU.simple_write(file_path: Saily.files.repo_list_signal, file_content: "INITED")
        }
    }
    
    func resave() {
        var out = ""
        for item in self.repos {
            out = item.link.major + "\n"
        }
        Saily_FileU.simple_write(file_path: Saily.files.repo_list, file_content: out)
    }
    
}

class a_repo {
    public var name             = String()
    public var link             = repo_link()
    public var section_root     = [repo_section_ins]()
    init(ilink: String) {
        self.link.apart_init(major_link: ilink)
    }
}

class repo_link {
    public var major           = String()
    public var icon            = String()
    public var cache_root      = String()
    public var cache_icon      = String()
    public var cache_release   = String()
    func apart_init(major_link: String) {
        self.major = major_link
    }
}

class repo_section_ins {
    
}
