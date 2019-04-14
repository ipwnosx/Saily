//
//  GobalVars.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import Foundation

import Alamofire
import SwiftyJSON
import SwifterSwift

// This session, variable decide app performance and behave.
var canTheAppHaveTFP0               = false
var canTheAppHaveSandboxEscape      = false
var canTheAppHaveRoot               = false
var canTheAppAccessNetWork          = false
var shouldAppDisableEffect          = false
let isInDebugSession                = false

// This session, contains basic file struct used in Saily Package Manager.
// ----> appRootFileSystem -->> "/var/root/Saily"
// --------------------------------------------->"/repos"
//                                                |->"/repo.list"                   <-> Text file contains repos links each line.
// ---------------------------------------------------->"/$repo_cache_named_name/"  <-> Folder with repo's name to be used as cache.
var appRootFileSystem               = "/var/root/Saily"
var newPackageHandlerEnabled        = false    // <--- Kids don't enable this. I'm trying to replace dpkg in some time.

// This session,..... I don't know haha.
let lowEffectDevices = ["iPod Touch 5", "iPod Touch 6", "iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5c",
                        "iPhone 5s", "iPhone 6", "iPhone 6", "iPhone 6 Plus","iPhone 6s", "iPhone 6s Plus", "iPhone SE",
                        "iPad 2", "iPad 3", "iPad 4", "iPad Air", "iPad 5", "iPad Mini", "iPad Mini 2", "iPad Mini 3", "iPad Mini 4"]

// This session, common check, future use. Don't worry, I'll handle this.
var didJailbrokenEver               = false
var didInstalledCydia               = false
var didInstalledSileo               = false
var didInstalledSailyToRoot         = false
var didInstalledidncare             = false     // idncare = I don't care.


// This session, #define return status.
let returnStatusSuccess             =  0            // common return value.
let returnStatusEPERMIT             = -1            // app is not in root with setuid(0) and sandbox escape.
let returnStatusEREFRESH            = -2            // app is not in root with setuid(0) and sandbox escape.
let returnStatusECONFILCT           = -3            // if we don't need to know more, use this one to block operation instead.
let returnStatusECONFILCT_FILE      = -4            // the app's document direction contains something wrong... for future use.
let returnStatusECONFILCT_TASK      = -5            // when apt or dpkg or may be cydia, is running, so block it for safety reason.

// This session, handling the repo operations.
let repoRefreshQuene                = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.repo.operation.refresh",
                                                    qos: .utility, attributes: .concurrent)
let NetworkCommonQuene              = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.network.operations",
                                                    qos: .utility, attributes: .concurrent)
let WatchDog                        = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.watchDogs",
                                                    qos: .utility, attributes: .concurrent)

// This session, contains device info, which is mostly privately. Take good care of this.
var deviceInfo_UDID = ""
var deviceVersion   = UIDevice.current.systemVersion
var deviceIdentifier   = ""

// This session, is for bridge call to Obj-C and future call to c.
let SailyBridgerOBJCObjectInitED = SailyCommonObject()

//        // This session saves the data request.
//        var dataRequsetArray = [DataRequest]()
//        var dataRequsetIfAvailable = [Bool]()
//        var inDataRequsetIfAvailableCheck = false

// In this session, jailbroken detect.
let jailbrokenSignalFiles = ["/private/var/stash",
                             "/private/var/lib/apt",
                             "/private/var/tmp/cydia.log",
                             "/Library/MobileSubstrate/MobileSubstrate.dylib",
                             "/var/cache/apt",
                             "/var/lib/apt",
                             "/var/lib/cydia",
                             "/var/log/syslog",
                             "/var/tmp/cydia.log",
                             "/bin/bash",
                             "/bin/sh",
                             "/usr/sbin/sshd",
                             "/usr/libexec/ssh-keysign",
                             "/usr/sbin/sshd",
                             "/usr/bin/sshd",
                             "/usr/libexec/sftp-server",
                             "/etc/ssh/sshd_config",
                             "/etc/apt",
                             
                             "/Applications/Cydia.app",
                             "/Applications/Sileo.app",
                             "/Applications/Saily Package Manager.app"]

