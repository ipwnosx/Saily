//
//  OperatorsClass.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation

import Alamofire

let Saily_FileU = Saily_File_Unit()
class Saily_File_Unit {
    
    func exists(file_path: String) -> Bool {
        return FileManager.default.fileExists(atPath: file_path)
    }
    
    func make_sure_file_exists_at(_ path: String, is_direct: Bool) {
        if (!FileManager.default.fileExists(atPath: path)) {
            if (is_direct) {
                try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }else{
                FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            }
        }
    }
    
    func simple_read(_ file_path: String) -> String? {
        let url0 = URL.init(fileURLWithPath: file_path)
        guard let data = try? Data.init(contentsOf: url0) else { return nil }
        var ret: String? = nil
        ret = String.init(data: data, encoding: .utf8)
        if (ret != "" && ret != nil) {
            return ret
        }
        ret = String.init(data: data, encoding: .ascii)
        if (ret != "" && ret != nil) {
            return ret
        }
        return nil
    }
    
    func simple_write(file_path: String, file_content: String) {
        if (FileManager.default.fileExists(atPath: file_path)) {
            try? FileManager.default.removeItem(atPath: file_path)
        }
        FileManager.default.createFile(atPath: file_path, contents: nil, attributes: nil)
        try? file_content.write(toFile: file_path, atomically: true, encoding: .utf8)
    }
    
    func decompress(file: String) -> Int{
        if (!self.exists(file_path: file)) {
            return status_ins.ret_failed
        }
        guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: file)) else { return status_ins.ret_failed }
        guard let type = file.split(separator: ".").last else { return status_ins.ret_failed }
        var ret: Data? = nil
        switch type.uppercased() {
        case "bz".uppercased():
            ret = Saily.objc_bridge.unBzip(data)
        case "bz2".uppercased():
            ret = Saily.objc_bridge.unBzip(data)
        case "gz".uppercased():
            ret = Saily.objc_bridge.unGzip(data)
        case "gz2".uppercased():
            ret = Saily.objc_bridge.unGzip(data)
        default:
            return status_ins.ret_failed
        }
        if (ret == nil) {
            return status_ins.ret_failed
        }
        try? FileManager.default.removeItem(atPath: file + ".out")
        FileManager.default.createFile(atPath: file + ".out", contents: ret, attributes: nil)
        return status_ins.ret_success
    }
}

let CydiaNetwork = CydiaNetwork_C()
class CydiaNetwork_C {
    public let UA_Default                                  = "Telesphoreo APT-HTTP/1.0.592"
    public let UA_Sileo                                    = "Sileo/1 CFNetwork/974.2.1 Darwin/18.0.0"
    public let UA_Web_Request_iOS_old                      = "Cydia/0.9 CFNetwork/342.1 Darwin/9.4.1"
    public let UA_Web_Request_iOS_12                       = "Cydia/0.9 CFNetwork/974.2.1 Darwin/18.0.0"
    public var H_UDID                                      = "X-Unique-ID:"        //X-Unique-ID: 40nums/chars
    public var H_Firmware                                  = "X-Firmware:"         //X-Firmware: 10.1.1
    public var H_Machine                                   = "X-Machine:"          //X-Machine: iPhone6,1
    private var init_ed                                    = false
    
    func apart_init(udid: String, firmare: String, machine: String) {
        if (self.init_ed) { return }
        self.H_UDID     = udid
        self.H_Firmware = firmare
        self.H_Machine  = machine
        self.init_ed    = true
    }
}

let AFF = AFNetwork_C()
class AFNetwork_C {
    private let release_search_path          = ["Packages.bz2",
                                                "Packages.gz",
                                                "dists/stable/main/binary-iphoneos-arm/Packages.bz2",
                                                "dists/stable/main/binary-iphoneos-arm/Packages.gz",
                                                "dists/hnd/main/binary-iphoneos-arm/Packages.bz2",
                                                "dists/tangelo/main/binary-iphoneos-arm/Packages.bz2",
                                                "dists/tangelo/main/binary-iphoneos-arm/Packages.gz",
                                                "dists/unstable/main/binary-iphoneos-arm/Packages.bz2",
                                                "dists/unstable/main/binary-iphoneos-arm/Packages.gz",
                                                "dists/unstable/main/binary-iphoneos-arm/Packages",
                                                "dists/stable/main/binary-iphoneos-arm/Packages",
                                                "dists/tangelo/main/binary-iphoneos-arm/Packages",
                                                "Packages"]
    
    func search_release_path_at_return(_ major_link: String, cache_release_link: String, end_call: @escaping (Int) -> ()) {
        if (Saily_FileU.exists(file_path: cache_release_link)) {
            if (Saily_FileU.simple_read(cache_release_link) != nil && Saily_FileU.simple_read(cache_release_link) != "") {
                end_call(status_ins.ret_success)
                return
            }
        }
        
        for item in self.release_search_path {
            if let url0 = URL.init(string: major_link + item) {
                let h: HTTPHeaders  = ["User-Agent" : CydiaNetwork.UA_Sileo,
                                       "X-Firmware" : CydiaNetwork.H_Firmware,
                                       "X-Unique-ID" : CydiaNetwork.H_UDID,
                                       "X-Machine" : CydiaNetwork.H_Machine,
                                       "Accept" : "*/*",
                                       "Accept-Language" : "zh-CN,en,*",
                                       "Accept-Encoding" : "gzip, deflate",
                                       "Connection" : "Keep-Alive",
                                       "Host" : String(major_link.split(separator: "/")[1])]
                print("[*] Attempt to connect for: " + url0.absoluteString)
                let s = DispatchSemaphore.init(value: 0)
                var b = false
                var re_map_to : String? = nil
                AF.request(url0, method: .get, headers: h).response { (res) in
                    if (res.response?.statusCode ?? 0 == 200) {
                        b = true
                    }else if (res.data != nil) {
                        if (res.response?.statusCode == 302) {
                            print("[*] Found a 302 respond: " + (String.init(data: res.data!, encoding: .utf8)?.description ?? "NAN"))
                            re_map_to = res.response?.allHeaderFields["Location"] as? String
                        }
                    }
                    s.signal()
                }
                s.wait()
                if (b == true) {
                    print("[*] FOUND RELEASE: " + major_link + item)
                    Saily_FileU.simple_write(file_path: cache_release_link, file_content: major_link + item)
                    end_call(status_ins.ret_success)
                    return
                }else if (re_map_to != nil){
                    
                }
            }
        }
        end_call(status_ins.ret_failed)
        return
    }
    
    func download_release_and_save(you: a_repo, manually_refreseh: Bool, end_call: @escaping (Int) -> ()) {
        let back_end = you.ress.cache_release_c_link.split(separator: ".").last?.description ?? "NAN"
        if (you.ress.cache_release.split(separator: ".").last?.description != back_end) {
            you.ress.cache_release += "."
            you.ress.cache_release += back_end
        }
        
        if (!manually_refreseh && Saily_FileU.exists(file_path: you.ress.cache_release)) {
            end_call(status_ins.ret_success)
            return
        }
        guard let url0 = URL.init(string: you.ress.cache_release_c_link) else {
            end_call(status_ins.ret_failed)
            return
        }
        let h: HTTPHeaders  = ["User-Agent" : CydiaNetwork.UA_Sileo,
                               "X-Firmware" : CydiaNetwork.H_Firmware,
                               "X-Unique-ID" : CydiaNetwork.H_UDID,
                               "X-Machine" : CydiaNetwork.H_Machine,
                               "Accept" : "*/*",
                               "Accept-Language" : "zh-CN,en,*",
                               "Accept-Encoding" : "gzip, deflate"]
        print("[*] Attempt to connect for: " + url0.absoluteString + " refetch? " + manually_refreseh.description)
        let destination: DownloadRequest.Destination = { _, _ in
            let furl0 = URL.init(fileURLWithPath: you.ress.cache_release + ".tmp")
            return (furl0, [.removePreviousFile, .createIntermediateDirectories])
        }
        if (you.ress.cache_release.split(separator: ".").last?.description != back_end) {
            you.ress.cache_release += "."
            you.ress.cache_release += back_end
        }
        AF.download(url0, headers: h, to: destination).downloadProgress { (progress) in
            you.async_set_progress(Float(progress.fractionCompleted * (0.666 - 0.233) + 0.233))
            }.responseData { (data) in
                print("[*] Download complete: " + you.name)
                end_call(status_ins.ret_success)
                return
        }
        
    }
    
    func test_a_url(url: URL, end_call: @escaping (Bool) -> ()) {
        AF.request(url).responseString { (data) in
            print("[*] Testing url: " + url.absoluteString + " returned: " + (data.value ?? "NAN"))
            if (data.value != nil || data.value != "") {
                print("[*] Testing url returns true.")
                end_call(true)
                return
            }else{
                print("[*] Testing url returns false.")
                end_call(false)
                return
            }
        }
    }
    
    func request_repo_icon(in_link: String, save_to: String, end_call :@escaping (UIImage) -> Void) {
        guard let url0 = URL.init(string: in_link + "CydiaIcon.png") else { return }
        let h: HTTPHeaders  = ["User-Agent" : CydiaNetwork.UA_Default,
                                     "X-Firmware" : CydiaNetwork.H_Firmware,
                                     "X-Unique-ID" : CydiaNetwork.H_UDID,
                                     "X-Machine" : CydiaNetwork.H_Machine,
                                     "If-None-Match" : "\"12345678-abcde\"",
                                     "If-Modified-Since" : "Fri, 12 May 2006 18:53:33 GMT",
                                     "Accept" : "*/*",
                                     "Accept-Language" : "zh-CN,en,*",
                                     "Accept-Encoding" : "gzip, deflate"]
        print("[*] Attempt to connect for icon: " + url0.absoluteString)
        AF.request(url0, headers: h).response { (dataRespone) in
            if (dataRespone.data != nil) {
                if let image = UIImage.init(data: dataRespone.data!) {
                    end_call(image)
                }
            }
        }
    }
    
}
