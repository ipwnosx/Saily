//
//  saily_codes_operations_network.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation
import UIKit
import Network
import Alamofire

// Headers from cydia:

let GVAR_Network_UserAgent_Default                  = "Telesphoreo APT-HTTP/1.0.592"
let GVAR_Network_UserAgent_Web_Request_iOS_old      = "Cydia/0.9 CFNetwork/342.1 Darwin/9.4.1"
let GVAR_Network_UserAgent_Web_Request_iOS_12       = "Cydia/0.9 CFNetwork/974.2.1 Darwin/18.0.0"

var GVAR_Network_Headers_UDID                       = "X-Unique-ID:"
var GVAR_Network_Firmware                           = "X-Firmware:"
var GVAR_Network_Machine                            = "X-Machine:"

// Thanks to Slava Karpenko, auth of icy
let GVAR_Network_REPO_Release_Search_Path           = ["Release",
                                                       "dists/stable/main/Release",
                                                       "dists/tangelo/main/Release",
                                                       "dists/hnd/main/Release",]
let GVAR_Network_REPO_Packages_Search_Path          = ["Packages.bz2",
                                                       "Packages.gz",
                                                       "Packages",
                                                       "dists/stable/main/binary-iphoneos-arm/Packages.bz2",
                                                       "dists/stable/main/binary-iphoneos-arm/Packages.gz",
                                                       "dists/stable/main/binary-iphoneos-arm/Packages",
                                                       "dists/tangelo/main/binary-iphoneos-arm/Packages.bz2",
                                                       "dists/tangelo/main/binary-iphoneos-arm/Packages.gz",
                                                       "dists/tangelo/main/binary-iphoneos-arm/Packages",
                                                       "dists/unstable/main/binary-iphoneos-arm/Packages.bz2",
                                                       "dists/unstable/main/binary-iphoneos-arm/Packages.gz",
                                                       "dists/unstable/main/binary-iphoneos-arm/Packages",
                                                       "dists/hnd/main/binary-iphoneos-arm/Packages.bz2"]


func sco_Network_search_for_packages_and_return_release_link(repo: repo, completionHandler: @escaping (_ link: String) -> () ) -> () {
    print("[*] query for release link with major_link at:" + repo.links.major)
    let read_cache = try? String.init(contentsOfFile: repo.name + ".info.release.link")
    if (read_cache != nil && read_cache != "") {
        print("[*] return cached release link at: " + read_cache!)
        completionHandler(read_cache!)
        return
    }
    let headers: HTTPHeaders  = ["User-Agent" : GVAR_Network_UserAgent_Default,
                                 "X-Firmware" : GVAR_device_info_current_version,
                                 "X-Unique-ID" : GVAR_device_info_UDID,
                                 "X-Machine" : GVAR_device_info_identifier,
                                 "If-None-Match" : "\"12345678-abcde\"",
                                 "If-Modified-Since" : "Fri, 12 May 2006 18:53:33 GMT",
                                 "Accept" : "*/*",
                                 "Accept-Language" : "zh-CN,en,*",
                                 "Accept-Encoding" : "gzip, deflate"]
    for item in GVAR_Network_REPO_Packages_Search_Path {
        // Sample ht tp://apt.thebigboss.org/repofiles/cydia/ <--Major Link | Search Path--> dists/stable/main/binary-iphoneos-arm/Packages.bz2
        if let url = URL.init(string: repo.links.major + item) {
            let s = DispatchSemaphore.init(value: 0)
            var b = false
            var re_map_to : String? = nil
            AF.request(url, method: .head, headers: headers).response { (res) in
                if (res.response?.statusCode ?? 0 >= 200 && res.response?.statusCode ?? 0 <= 300) {
                    b = true
                }
                if (res.response?.statusCode == 302) {
                    // REMAP TO PACKAGE
//                    HTTP/1.1 302 Found
//                    Cache-Control: no-cache
//                    Content-length: 0
//                    Location: https://apt.bingner.com/Packages.bz2
                    re_map_to = res.response?.allHeaderFields["Location"] as? String
                    if (re_map_to != nil) {
                        b = true
                    }
                }
                s.signal()
            }
            s.wait()
            if (b) {
                if (re_map_to != nil) {
                    completionHandler(re_map_to!)
                    print("[*] return release link at:" + re_map_to!)
                    return
                }
                completionHandler(repo.links.major + item)
                print("[*] return release link at:" + repo.links.major + item)
                return
            }
        }
    }
    print("[E] Error query for repo release link at: " + repo.links.major)
    completionHandler("ERROR_SEARCHING_RELEASE_PACKAGES")
    return
}

func sco_Network_download_release_from_link(repo: repo, completionHandler: @escaping (_ file_name: String) -> ()) -> Void {
    let headers: HTTPHeaders  = ["User-Agent" : GVAR_Network_UserAgent_Default,
                                 "X-Firmware" : GVAR_device_info_current_version,
                                 "X-Unique-ID" : GVAR_device_info_UDID,
                                 "X-Machine" : GVAR_device_info_identifier,
                                 "If-None-Match" : "\"12345678-abcde\"",
                                 "If-Modified-Since" : "Fri, 12 May 2006 18:53:33 GMT",
                                 "Accept" : "*/*",
                                 "Accept-Language" : "zh-CN,en,*",
                                 "Accept-Encoding" : "gzip, deflate"]
    guard let url = URL.init(string: repo.links.release) else { return }
    let s = DispatchSemaphore.init(value: 0)
    var back_end = repo.links.release.split(separator: ".").last?.description
    if (back_end?.count ?? "nonononon".count >= 5) {
        back_end = "none"
    }
    let file_path = GVAR_behave_repo_info_cache_folder_path + "/" + repo.name + ".release." + back_end!
    try? FileManager.default.removeItem(atPath: file_path + ".tmp")
    var failed = false
    print("[*] starting download repo release at: " + repo.name)
    AF.request(url, headers: headers).response { (datas) in
        guard let data = datas.data else { failed = true; s.signal(); return }
        FileManager.default.createFile(atPath: file_path + ".tmp", contents: data, attributes: nil)
        try? FileManager.default.removeItem(atPath: file_path)
        try? FileManager.default.moveItem(atPath: file_path + ".tmp", toPath: file_path)
        s.signal()
    }
    s.wait()
    if (failed) {
        completionHandler("ERROR DOWNLOAD")
        return
    }
    completionHandler(file_path)
}

func sco_Network_return_CydiaIcon(repo: repo, force_refetch: Bool, completionHandler: @escaping (_ image: UIImage) -> Void) -> Void {
    let save_path = GVAR_behave_repo_icon_cache_folder_path + "/" + repo.name + ".png"
    if (FileManager.default.fileExists(atPath: save_path)) {
        print("[*] return cached image at: " + save_path)
        if let image = UIImage.init(contentsOfFile: save_path) {
            completionHandler(image)
            return
        }
    }
    if (repo.name == "The Big Boss") {
        completionHandler(#imageLiteral(resourceName: "repo_bigboss.png"))
        return
    }
    print("[*] Attempt to connect: " + repo.links.icon)
    guard let url = URL.init(string: repo.links.icon) else { return }
    let headers: HTTPHeaders  = ["User-Agent" : GVAR_Network_UserAgent_Web_Request_iOS_12,
                                 "X-Firmware" : GVAR_device_info_current_version,
                                 "X-Unique-ID" : GVAR_device_info_UDID,
                                 "X-Machine" : GVAR_device_info_identifier,
                                 "If-None-Match" : "\"12345678-abcde\"",
                                 "If-Modified-Since" : "Fri, 12 May 2006 18:53:33 GMT",
                                 "Accept" : "*/*",
                                 "Accept-Language" : "zh-CN,en,*",
                                 "Accept-Encoding" : "gzip, deflate"]
    // The Big Boss's icon looks ugly.
//    if (sco_repos_link_to_name(link: link) == "The Big Boss") {
//        url = URL.init(string: "http://apt.thebigboss.org/repofiles/cydia/dists/stable/CydiaIcon.png")!
//        return
//    }
    AF.request(url, headers: headers).response { (data_s) in
        guard let data = data_s.data else {
            return
        }
        guard let image = UIImage.init(data: data) else {
            return
        }
        if let pngFile = image.pngData() {
            FileManager.default.createFile(atPath: save_path, contents: pngFile, attributes: nil)
        }
            completionHandler(image)
    }
}

