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
    public var repos                = [a_repo]()
    public var status               = status_ins.ready
    public var boot_time_refresh    = true
    
    func apart_init() {
        self.status = status_ins.in_operation
        if (Saily_FileU.exists(file_path: Saily.files.repo_list_signal)) {
            let read = Saily_FileU.simple_read(Saily.files.repo_list)
            for item in read?.split(separator: "\n") ?? [] {
                let repo = a_repo(ilink: item.description)
                self.repos.append(repo)
            }
        }else{
            let default_links = ["http://repounclutter.coolstar.org/",
                                 "https://apt.bingner.com/",
                                 "http://build.frida.re/",
                                 "https://repo.chariz.io/",
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
    
    func refresh_call() {
        for item in self.repos {
            if (item.status == status_ins.in_operation) {
                return
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    item.exposed_progress_view.progressTintColor = .blue
                })
            }
            item.status = status_ins.in_operation
            item.async_set_progress(0.1)
            Saily.operation_quene.network_queue.async {
                item.download_section(manually_refreseh: !self.boot_time_refresh) { (ret) in
                    if (ret == status_ins.ret_success)
                    {
                        item.async_set_progress(0.75)
                        Saily.operation_quene.wrapper_queue.asyncAfter(deadline: .now() + 1, execute: {
                            if (item.status != status_ins.in_wrapper) {
                                item.status = status_ins.in_wrapper
                            }else{
                                return
                            }
                            print("[*] In wrapper")
                            let tmp_path = item.ress.cache_release + ".tmp"
                            try? FileManager.default.removeItem(atPath: item.ress.cache_release)
                            try? FileManager.default.moveItem(atPath: tmp_path, toPath: item.ress.cache_release)
                            _ = Saily_FileU.decompress(file: item.ress.cache_release)
                            item.async_set_progress(0.8)
                            item.init_section(end_call: { (rett) in
                                if (rett == status_ins.ret_success)
                                {
                                    item.async_set_progress(1)
                                    item.status = status_ins.ready
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        item.exposed_progress_view.progress = 0
                                    })
                                    Saily.rebuild_All_My_Packages()
                                }else{
                                    DispatchQueue.main.async {
                                        UIView.animate(withDuration: 0.2, animations: {
                                            item.exposed_progress_view.progressTintColor = .red
                                        })
                                    }
                                    item.status = status_ins.ready
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                        item.exposed_progress_view.progress = 0
                                    })
                                }
                            })
                        })
                    }else{
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.2, animations: {
                                item.exposed_progress_view.progressTintColor = .red
                            })
                        }
                        item.status = status_ins.ready
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            item.exposed_progress_view.progress = 0
                        })
                    }
                }
            }
        }
    }
    

}

class a_repo {
    public var name                     = String()
    public var status                   = Int()
    public var ress                     = repo_res()
    public var section_root             = [repo_section_C]()
    
    // From table view, expose an element.
    public var exposed_icon_image       = UIImageView()
    public var exposed_progress_view    = UIProgressView()
    
    func sort_sections() {
        var names = [String]()
        for section in section_root {
            names.append(section.name)
        }
        names.sort()
        var new = [repo_section_C]()
        for na in names {
            new.append(self.section_root[ensure_section_and_return_index(withName: na)])
        }
        self.section_root = new
    }
    
    func ensure_section_and_return_index(withName: String) -> Int {
        var index = 0
        for item in self.section_root {
            if (item.name == withName) {
                return index
            }
            index += 1
        }
        let new_session = repo_section_C()
        new_session.name = withName
        section_root.append(new_session)
        return index
    }
    
    // avoid fail when cell is out and re init.
    func set_exposed_progress_view(_ i: UIProgressView) {
        let prog = self.exposed_progress_view.progress
        self.exposed_progress_view = i
        self.async_set_progress(prog)
    }
    
    init(ilink: String) {
        _ = self.link_to_name(link: ilink)
        self.ress.apart_init(major_link: ilink, name: self.name)
    }
    
    func link_to_name(link: String) -> String {
        if (self.name != "") {
            return self.name
        }
        if (link.contains("repounclutter.coolstar.org")) {
            let namee = "The Big Boss+"
            self.name = namee
            return namee
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
    
    func async_set_progress(_ prog: Float) {
        if (prog == 1) {
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.exposed_progress_view.setProgress(1.0, animated: true)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    self.exposed_progress_view.setProgress(0, animated: false)
                })
            }
            return
        }
        DispatchQueue.main.async {
            self.exposed_progress_view.setProgress(prog, animated: true)
        }
    }
    
    func download_section(manually_refreseh: Bool, end_call: @escaping (Int) -> ()) {
        Saily.operation_quene.network_queue.async {
            AFF.search_release_path_at_return(self.ress.major, cache_release_link: self.ress.cache_release_f_link, end_call: { (ret_status) in
                if (ret_status == status_ins.ret_success) {
                    self.async_set_progress(0.233)
                    self.ress.cache_release_c_link = Saily_FileU.simple_read(self.ress.cache_release_f_link)!
                    // START DOWNLOAD
                    AFF.download_release_and_save(you: self, manually_refreseh: manually_refreseh, end_call: { (rett) in
                        if (rett == status_ins.ret_success) {
                            self.async_set_progress(0.7)
                            end_call(status_ins.ret_success)
                            return
                        }else{
                            DispatchQueue.main.async {
                                self.exposed_progress_view.progressTintColor = .red
                            }
                            end_call(status_ins.ret_failed)
                            return
                        }
                    })
                }else{
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.exposed_progress_view.progressTintColor = .red
                        })
                    }
                    end_call(status_ins.ret_failed)
                    return
                }
            })
        }
    }
    
    func init_section(end_call: @escaping (Int) -> ()) {
        // return if success
        let file_url = URL.init(fileURLWithPath: self.ress.cache_release + ".out")
        guard let data = try? Data.init(contentsOf: file_url) else {
            end_call(status_ins.ret_failed)
            return
        }
        var str: String? = nil
        str = String.init(data: data, encoding: .utf8)
        if (str == nil || str == "") {
            str = String.init(data: data, encoding: .ascii)
        }
        if (str == nil || str == "") {
            end_call(status_ins.ret_failed)
            return
        }
        
        var info_head = ""
        var info_body = ""
        var in_head = true
        var line_break = false
        var this_package = packages_C()
        for char in str! {
            let c = char.description
            inner: if (c == ":") {
                line_break = false
                in_head = false
            }else if (c == "\n") {
                if (line_break == true) {
                    // create section, put the package
                    self.section_root[self.ensure_section_and_return_index(withName: this_package.info["Section".uppercased()] ?? "! NAN Section")].add(p: this_package)
//                    self.lldb_print_package(p: this_package)
                    // next package
                    this_package = packages_C()
                    break inner
                }
                line_break = true
                in_head = true
                if (info_head == "" || info_body == "") {
                    break inner
                }
                while (info_head.hasPrefix("\n")) {
                    info_head = String(info_head.dropFirst())
                }
                info_body = String(info_body.dropFirst(1))
                this_package.info[info_head.uppercased()] = info_body
                info_head = ""
                info_body = ""
                if (in_head) {
                    info_head += c
                }else{
                    info_body += c
                }
            }else{
                line_break = false
                if (in_head) {
                    info_head += c
                }else{
                    info_body += c
                }
            }
        }
        
        self.sort_sections()
        end_call(status_ins.ret_success)
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
    public var major                        = String()
    public var icon                         = UIImage()
    public var cache_root                   = String()
    public var cache_icon                   = String()
    public var cache_release                = String()
    public var cache_release_f_link         = String()
    public var cache_release_c_link         = String()
    func apart_init(major_link: String, name: String) {
        self.major = major_link
        self.cache_root = Saily.files.repo_cache + "/" + name
        self.cache_icon = self.cache_root + "/icon.png"
        self.cache_release = self.cache_root + "/release"
        self.cache_release_f_link = self.cache_root + "/release.lnk"
        self.cache_release_c_link = Saily_FileU.simple_read(self.cache_release_f_link) ?? ""
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
    public  var name = String()
    public  var packages = [packages_C]()
    private var packages_name_list = [String : String]()
    
    func lldb_print_package(p: packages_C) {
//        print("[*] --------------------------------- ")
//        for item in p.info {
//            print(item)
//        }
//        print("[*] --------------------------------- ")
    }
    
    func add(p: packages_C) {
        
        let np: String = p.info["Package".uppercased()]!
        if (self.packages_name_list[np] != "" && self.packages_name_list[np] != nil) {
            // package exists
            print("[*] Package " + np + " exists at version: " + (p.info["Version".uppercased()] ?? "0"))
            let newV = p.info["Version".uppercased()] ?? "0"
            // search for package
            var index = 0
            inner: for item in self.packages {
                if (item.info["Package".uppercased()] == np) {
                    break inner
                }else{
                    index += 1
                }
            }
            let oldV = self.packages[index].info["Version".uppercased()] ?? "-1"
            if oldV.compare(newV, options: NSString.CompareOptions.numeric, range: nil, locale: nil) == ComparisonResult.orderedDescending {
            }else{
                // new one!
                self.packages[index] = p
                self.lldb_print_package(p: packages[index])
            }
        }else{
            packages_name_list[np] = p.info["Version".uppercased()] ?? "0"
            packages.append(p)
            self.lldb_print_package(p: p)
        }
    }
}

class packages_C {
    public var info = [String : String]()
}
