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

let GVAR_Network_UserAgent_Default                  = "Telesphoreo APT-HTTP/1.0.534"
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




func sco_Network_return_CydiaIcon(link: String, force_refetch: Bool, completionHandler: @escaping (_ image: UIImage) -> Void) -> Void {
    let save_path = GVAR_behave_repo_icon_cache_folder_path + "/" + sco_repos_link_to_name(link: link) + ".png"
    if (FileManager.default.fileExists(atPath: save_path)) {
        print("[*] return cached image at: " + save_path)
        if let image = UIImage.init(contentsOfFile: save_path) {
            completionHandler(image)
            return
        }
    }
    if (sco_repos_link_to_name(link: link) == "The Big Boss") {
        completionHandler(#imageLiteral(resourceName: "repo_bigboss.png"))
        return
    }
    guard let url = URL.init(string: link) else { return }
    let headers: HTTPHeaders  = ["User-Agent" : GVAR_Network_UserAgent_Web_Request_iOS_12,
                                 "If-None-Match" : "\"12345678-abcde\"",
                                 "If-Modified-Since" : "Fri, 12 May 2006 18:53:33 GMT",
                                 "Accept" : "*/*",
                                 "Accept-Language" : "zh-cn",
                                 "Accept-Encoding" : "gzip, deflate"]
    // Alamofire.request(endPoint , method: .post, parameters: parameter ,encoding: JSONEncoding.default , headers: header).validate(statusCode: 200..<300).responseObject { (response: DataResponse<SomeModel>) in
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
