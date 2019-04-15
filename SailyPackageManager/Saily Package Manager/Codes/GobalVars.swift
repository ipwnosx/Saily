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
let behave_debug_session_enabled                        = false
var behave_daemon_loaded                                = false
var behave_network_available                            = false

// This session, contains basic file struct used in Saily Package Manager.
var behave_app_root_file_path                           = ""
var behave_repo_list_file_path                          = ""

// This session, contain file struct.
var saily_repo_list_instance                            = [String]()

// This session, contains device info for repo request.
var device_info_UDID                                    = String()
var device_info_identifier                              = String()
var device_info_identifier_human_readable               = String()
var device_info_current_version                         = String()

// This session, #define return status.
let rts_SUCCESS                                         =  0            // common return value.
let rts_EPERMIT                                         = -1            // app is not in root with setuid(0) and sandbox escape.
let rts_EREFRESH                                        = -2            // app is not in root with setuid(0) and sandbox escape.
let rts_ECONFILCT                                       = -3            // if we don't need to know more, use this one to block operation instead.
let rts_ECONFILCT_FILE                                  = -4            // the app's document direction contains something wrong... for future use.
let rts_ECONFILCT_TASK                                  = -5            // when apt or dpkg or may be cydia, is running, so block it for safety reason.

// This session, handling the repo operations.
let repo_operations_quene                               = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.repo.operation.refresh",
                                                                        qos: .utility, attributes: .concurrent)
let network_operations_quene                            = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.network.operations",
                                                                        qos: .utility, attributes: .concurrent)
let watch_dogs_control_quene                            = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.watchDogs",
                                                                        qos: .utility, attributes: .concurrent)

// This session, is for bridge call to Obj-C and future call to c.
let const_objc_bridge_object_                           = SailyCommonObject()

// In this session, jailbroken detect.
let const_has_jailbroken_signal                         = ["/private/var/stash",
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

