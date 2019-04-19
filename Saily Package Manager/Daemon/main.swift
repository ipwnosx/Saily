//
//  main.cpp
//  Daemon
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright (c) 2019 Lakr233. All rights reserved.
//

// LIBSWIFT MAYBE NEEDED
// we use a notify_call to make it able to change the sign id.

import Foundation

var session_port  = ""
var session_token = ""

func notify_call_start_init_port (
                                  arg1: CFNotificationCenter?,
                                  arg2: UnsafeMutableRawPointer?,
                                  arg3: CFNotificationName?,
                                  arg4: UnsafeRawPointer?,
                                  arg5: CFDictionary?) -> Void {
    session_port = ""
}
func notify_call_add_port_number_0 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "0"
}
func notify_call_add_port_number_1 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "1"
}
func notify_call_add_port_number_2 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "2"
}
func notify_call_add_port_number_3 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "3"
}
func notify_call_add_port_number_4 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "4"
}
func notify_call_add_port_number_5 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "5"
}
func notify_call_add_port_number_6 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "6"
}
func notify_call_add_port_number_7 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "7"
}
func notify_call_add_port_number_8 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "8"
}
func notify_call_add_port_number_9 (
                                    arg1: CFNotificationCenter?,
                                    arg2: UnsafeMutableRawPointer?,
                                    arg3: CFNotificationName?,
                                    arg4: UnsafeRawPointer?,
                                    arg5: CFDictionary?) -> Void {
    session_port += "9"
}
func notify_call_end_read_port (
                                arg1: CFNotificationCenter?,
                                arg2: UnsafeMutableRawPointer?,
                                arg3: CFNotificationName?,
                                arg4: UnsafeRawPointer?,
                                arg5: CFDictionary?) -> Void {
    // look_for for session_token
}

func notify_call_submit_job_quene (
                                   arg1: CFNotificationCenter?,
                                   arg2: UnsafeMutableRawPointer?,
                                   arg3: CFNotificationName?,
                                   arg4: UnsafeRawPointer?,
                                   arg5: CFDictionary?) -> Void {
    // look for date
    
}

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_start_init_port,
                                "com.Saily.session.init.start_read_port" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_0,
                                "com.Saily.session.init.addport.0" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_1,
                                "com.Saily.session.init.addport.1" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_2,
                                "com.Saily.session.init.addport.2" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_3,
                                "com.Saily.session.init.addport.3" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_4,
                                "com.Saily.session.init.addport.4" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_5,
                                "com.Saily.session.init.addport.5" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_6,
                                "com.Saily.session.init.addport.6" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_7,
                                "com.Saily.session.init.addport.7" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_8,
                                "com.Saily.session.init.addport.8" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_add_port_number_9,
                                "com.Saily.session.init.addport.9" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_end_read_port,
                                "com.Saily.session.init.end_read_port.8" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                notify_call_submit_job_quene,
                                "com.Saily.session.submit_job_quene" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)



CFRunLoopRun()



