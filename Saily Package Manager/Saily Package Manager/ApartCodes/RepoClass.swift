//
//  RepoClass.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
import UIKit

import MKRingProgressView

class repo_C {
    public var repos        = [a_repo]()
    public var status       = status_ins.ready
    
    func apart_init() {
        self.status = status_ins.in_operation
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
                out = out + item.description + "\n"
            }
            Saily_FileU.simple_write(file_path: Saily.files.repo_list, file_content: out)
            Saily_FileU.simple_write(file_path: Saily.files.repo_list_signal, file_content: "INITED")
        }
        self.status = status_ins.ready
    }
    
    func resave() {
        self.status = status_ins.in_operation
        print("[*] Begin saving repos...")
        var out = ""
        for item in self.repos {
            out = out + item.ress.major + "\n"
            print("[*] Saving repo: " + item.name)
        }
        Saily_FileU.simple_write(file_path: Saily.files.repo_list, file_content: out)
        print("[*] End saving repos")
        self.status = status_ins.ready
    }
    
}

class a_repo {
    public var name                     = String()
    public var ress                     = repo_res()
    public var section_root             = [repo_section_C]()
    
    // From table view, expose an element.
    public var exposed_icon_image       = UIImageView()
    public var exposed_progress_view    = RingProgressView()
    
    init(ilink: String) {
        _ = self.link_to_name(link: ilink)
        self.ress.apart_init(major_link: ilink, name: self.name)
    }
    
    func link_to_name(link: String) -> String {
        if (self.name != "") {
            return self.name
        }
        var namee = link.split(separator: "/")[1].description
        if (namee.split(separator: ".").count == 2) {
            namee = namee.split(separator: ".")[0].description
        }else{
            if (namee.split(separator: ".")[0] == "apt" || namee.split(separator: ".")[0] == "repo" || namee.split(separator: ".")[0] == "cydia") {
                namee = namee.split(separator: ".")[1].description
            }
        }
        namee = namee.first!.description.uppercased() + namee.dropFirst().description
        if (namee == "Thebigboss") {
            namee = "The Big Boss"
        }
        self.name = namee
        return namee
    }
    
    func download_section(end_call: @escaping (Int) -> ()) {
        // return if success
    }
    
    func init_section(end_call: @escaping (Int) -> ()) {
        // return if success
    }
    
    func init_icon() {
        DispatchQueue.main.async {
            self.exposed_icon_image.image = self.ress.icon
        }
        Saily.operation_quene.network_queue.async {
            if (!Saily_FileU.exists(file_path: self.ress.cache_icon) && self.name != "The Big Boss") {
                let s = DispatchSemaphore(value: 0)
                AFF.request_repo_icon(in_link: self.ress.major, save_to: self.ress.cache_icon) { (image) in
                    FileManager.default.createFile(atPath: self.ress.cache_icon, contents: image.pngData(), attributes: nil)
                    self.ress.init_icon()
                    s.signal()
                }
                s.wait()
            }
            DispatchQueue.main.async {
                self.exposed_icon_image.image = self.ress.icon
            }
        }
    }
    
    func table_view_init_call(end_call: @escaping () -> ()) {
        init_icon()
    }
}

class repo_res {
    public var major           = String()
    public var icon            = UIImage()
    public var cache_root      = String()
    public var cache_icon      = String()
    public var cache_release   = String()
    func apart_init(major_link: String, name: String) {
        self.major = major_link
        self.cache_root = Saily.files.repo_cache + "/" + name
        self.cache_icon = self.cache_root + "/icon.png"
        self.cache_release = self.cache_root + "/release"
        Saily_FileU.make_sure_file_exists_at(self.cache_root, is_direct: true)
        init_icon()
    }
    func init_icon() {
        if (self.major.contains("apt.thebigboss.org")) {
            self.icon = #imageLiteral(resourceName: "repo_bigboss.png")
        }else{
            if let image = UIImage.init(contentsOfFile: self.cache_icon) {
                self.icon = image
            }else{
                self.icon = #imageLiteral(resourceName: "iConRound.png")
            }
        }
    }
}

class repo_section_C {
    
}
