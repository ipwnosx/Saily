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
}

let CydiaNetwork = CydiaNetwork_C()
class CydiaNetwork_C {
    let UA_Default                                  = "Telesphoreo APT-HTTP/1.0.592"
    let UA_Web_Request_iOS_old                      = "Cydia/0.9 CFNetwork/342.1 Darwin/9.4.1"
    let UA_Web_Request_iOS_12                       = "Cydia/0.9 CFNetwork/974.2.1 Darwin/18.0.0"
    var H_UDID                                      = "X-Unique-ID:"        //X-Unique-ID: 40nums/chars
    var H_Firmware                                  = "X-Firmware:"         //X-Firmware: 10.1.1
    var H_Machine                                   = "X-Machine:"          //X-Machine: iPhone6,1
    private var init_ed                             = false
    func apart_init(udid: String, firmare: String, machine: String) {
        if (self.init_ed) { return }
        self.H_UDID     += udid
        self.H_Firmware += firmare
        self.H_Machine  += machine
        self.init_ed    = true
    }
}

let AFF = AFNetwork_C()
class AFNetwork_C {
    
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
