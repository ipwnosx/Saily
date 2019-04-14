//
//  main.cpp (Fuck it cpp.. hahahaa)
//  main.swift
//  SailyStartupDaemon
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright (c) 2019 Lakr Aream. All rights reserved.
//

// LIBSWIFT ONLY CONTAINS SWIFT 4.2.1 so, we are going to use it.

import Foundation

func daemonCallBack_reboot(
    arg1: CFNotificationCenter?,
    arg2: UnsafeMutableRawPointer?,
    arg3: CFNotificationName?,
    arg4: UnsafeRawPointer?,
    arg5: CFDictionary?) -> Void {
    reboot(0)
}

func daemonCallBack_bootstrap_overSockets_start(
    arg1: CFNotificationCenter?,
    arg2: UnsafeMutableRawPointer?,
    arg3: CFNotificationName?,
    arg4: UnsafeRawPointer?,
    arg5: CFDictionary?) -> Void {
    // Create Commuincation Over Socket With localhost:7280<->7288
    
}

func daemonCallBack_bootstrap_overSockets_stop(
    arg1: CFNotificationCenter?,
    arg2: UnsafeMutableRawPointer?,
    arg3: CFNotificationName?,
    arg4: UnsafeRawPointer?,
    arg5: CFDictionary?) -> Void {
    // Stop Commuincation Over Socket With localhost:7280<->7288
    
}

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                daemonCallBack_reboot,
                                "com.Saily.daemon.reboot" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                daemonCallBack_bootstrap_overSockets_start,
                                "daemonCallBack_bootstrap_overSockets_start" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                daemonCallBack_bootstrap_overSockets_stop,
                                "daemonCallBack_bootstrap_overSockets_stop" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)


CFRunLoopRun()



