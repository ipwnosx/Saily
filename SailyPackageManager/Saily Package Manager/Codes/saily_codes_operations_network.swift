//
//  saily_codes_operations_network.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation

// Headers from cydia:

let GVAR_Network_UserAgent_Default  = "Telesphoreo APT-HTTP/1.0.534"
let GVAR_Network_UserAgent_Extended = "Cydia/0.9 CFNetwork/342.1 Darwin/9.4.1"

var GVAR_Network_Headers_UDID       = "X-Unique-ID: "
var GVAR_Network_Firmware           = "X-Firmware: "
var GVAR_Network_Machine            = "X-Machine: "

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
