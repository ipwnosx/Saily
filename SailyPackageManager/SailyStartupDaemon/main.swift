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

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                nil,
                                daemonCallBack_reboot,
                                "com.Saily.daemon.reboot" as CFString,
                                nil,
                                CFNotificationSuspensionBehavior.deliverImmediately)

CFRunLoopRun()



