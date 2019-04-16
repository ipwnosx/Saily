//
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


// This session, #define return status.
let rts_SUCCESS                                         =  0            // common return value.
let rts_EPERMIT                                         = -1            // app is not in root with setuid(0) and sandbox escape.
let rts_EPERM_FILE_LOCK                                 = -2            // the app's document direction contains something wrong... for future use.

// This session, variable decide app performance and behave.
let GVAR_behave_debug_session_enabled                        = false
var GVAR_behave_daemon_loaded                                = false
var GVAR_behave_network_available                            = false
var GVAR_behave_should_run_setup                             = false
var GVAR_behave_app_setting                                  = [String : String]()

// This session, contains basic file struct used in Saily Package Manager.
var GVAR_behave_app_root_file_path                           = ""
var GVAR_behave_udid_path                                    = ""
var GVAR_behave_repo_list_file_path                          = ""
var GVAR_behave_repo_icon_cache_folder_path                  = ""
var GVAR_behave_job_quene_submit_path                        = ""

// This session, contain file struct.
var GVAR_behave_repo_list_instance                           = [String]()

// This session, contains device info for repo request.
var GVAR_device_info_UDID                                    = String()
var GVAR_device_info_identifier                              = String()
var GVAR_device_info_identifier_human_readable               = String()
var GVAR_device_info_current_version                         = String()

// This session, handling the repo operations.
let GCD_repo_operations_quene                                = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.repo.operation.refresh",
                                                                        qos: .utility, attributes: .concurrent)
let GCD_network_operations_quene                             = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.network.operations",
                                                                        qos: .utility, attributes: .concurrent)
let GCD_watch_dogs_control_quene                             = DispatchQueue(label: "com.lakr233.jw.Saily-Package-Manager.watchDogs",
                                                                        qos: .utility, attributes: .concurrent)

// This session, is for bridge call to Obj-C and future call to c.
let const_objc_bridge_object                            = SailyCommonObject()

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

