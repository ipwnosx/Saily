//
//  commonExtensions.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import Foundation

import Alamofire
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
var deviceVersion   = ""

// This session, is for bridge call to Obj-C and future call to c.
let SailyBridgerOBJCObjectInitED = SailyCommonObject()

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


func initCheck() -> Int {
    
    // test call chain to Obj-C
    SailyBridgerOBJCObjectInitED.testCall()
    
    // reduce effects when using......
    let thisDeviceIs = UIDevice.modelName
    for device in lowEffectDevices {
        if (thisDeviceIs == device) {
            shouldAppDisableEffect = true
            break
        }
    }
    
    // check if we have escaped sandbox
    try? FileManager.default.createDirectory(atPath: appRootFileSystem, withIntermediateDirectories: false, attributes: nil)
    try? FileManager.default.createDirectory(atPath: appRootFileSystem + "/.bootstrap_test", withIntermediateDirectories: false, attributes: nil)
    let bootstrap_test_fileTest_fileName = appRootFileSystem + "/.bootstrap_test/bootstrap_test_ID_" + UUID().uuidString
    FileManager.default.createFile(atPath: bootstrap_test_fileTest_fileName, contents: nil, attributes: nil)
    if (FileManager.default.fileExists(atPath: bootstrap_test_fileTest_fileName))
    {
        canTheAppHaveSandboxEscape = true
        try? FileManager.default.removeItem(atPath: bootstrap_test_fileTest_fileName)
    }else{
        appRootFileSystem = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("[*] Setting appRootFileSystem to sandboxed env at:" + appRootFileSystem)
    }
    
    // check if is jailbroken and more.
    for item in jailbrokenSignalFiles {
        if (FileManager.default.fileExists(atPath: item)) {
            didJailbrokenEver = true
        }
    }
    if (canOpenURLString(str: "cydia://") && FileManager.default.fileExists(atPath: "/Applications/Cydia.app")) {                   // because sileo contains cydia://
        didInstalledCydia = true
    }
    if (canOpenURLString(str: "sileo://") || FileManager.default.fileExists(atPath: "/Applications/Sileo.app")) {                   // That should be okay.
        didInstalledSileo = true
    }
    if (canOpenURLString(str: "saily://") || FileManager.default.fileExists(atPath: "/Applications/Saily Package Manager.app")) {    // I'll do my own.
        didInstalledSailyToRoot = true
    }
    
    if (didInstalledSailyToRoot == true) {                                                                                           // check if installed to root, but don't gain root.
        if (!canTheAppHaveRoot || !canTheAppHaveSandboxEscape) {
            return returnStatusEPERMIT
        }
    }
    
    // check if tfp0 export is enabled.
    canTheAppHaveTFP0 = SailyBridgerOBJCObjectInitED.has_tfp0_over_HSP4()
    
    // now let's get in root/
    canTheAppHaveRoot = SailyBridgerOBJCObjectInitED.isInRoot()
    
    return returnStatusSuccess
}

func initRepo() -> Int {
    // creating file and folder if there is no
    let repoCacheRootFilePath = appRootFileSystem + "/repos"
    let repoListFilePath = repoCacheRootFilePath + "/repos.list"
    try? FileManager.default.createDirectory(atPath: repoCacheRootFilePath, withIntermediateDirectories: true, attributes: nil)
    if (!FileManager.default.fileExists(atPath: repoListFilePath)) {
        FileManager.default.createFile(atPath: repoListFilePath, contents: nil, attributes: nil)
        // Write default repo to it.
        let defaultRepo = """
http://apt.thebigboss.org/repofiles/cydia/
https://apt.bingner.com/
http://build.frida.re/
https://repo.chariz.com/
https://repo.dynastic.co/
"""
        try? defaultRepo.write(toFile: repoListFilePath, atomically: true, encoding: .utf8)
        if (!FileManager.default.fileExists(atPath: repoListFilePath)) {
            return returnStatusEPERMIT
        }
        for this in defaultRepo.split(separator: "\n") {
            if (initRepoWith(link: this.description) == returnStatusEPERMIT) {
                return returnStatusEPERMIT
            }
        }
    }
    return returnStatusSuccess
}

func initRepoWith(link: String) -> Int {
    let repoCacheRootFilePath = appRootFileSystem + "/repos"
    let repoName = link.split(separator: "/")[1]
    try? FileManager.default.createDirectory(atPath: repoCacheRootFilePath + "/" + repoName, withIntermediateDirectories: true, attributes: nil)
    if (!FileManager.default.fileExists(atPath: repoCacheRootFilePath + "/" + repoName)) {
        return returnStatusEPERMIT
    }
    return returnStatusSuccess
}

func refreshRepos() -> Int {
    let repoListPath = appRootFileSystem + "/repos/repos.list"
    if (!FileManager.default.fileExists(atPath: repoListPath)) {
        if (initRepo() == returnStatusEPERMIT) {
            return returnStatusEPERMIT
        }
    }
    let repoList = try? String.init(contentsOfFile: repoListPath)
    if (repoList == "" || repoList == nil) {
        return returnStatusEPERMIT
    }
    for item in (repoList ?? "").split(separator: "\n") {
        _ = refreshRepoWith(link: item.description)
    }
    return returnStatusSuccess
}

func refreshRepoWith(link: String) -> Int {
    // repo is in quene, no need to add again.
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileLOCKPath = filePath + ".lck"
    if (FileManager.default.fileExists(atPath: fileLOCKPath)) {
        return returnStatusSuccess
    }
    FileManager.default.createFile(atPath: fileLOCKPath, contents: nil, attributes: nil)
    // sending to back ground quene
    repoRefreshQuene.async {
        _ = refreshCore(link: link)
        _ = removeRepoLock(link: link)
    }
    // always send returnStatusSuccess back because we want to handl error refresh later.
    return returnStatusSuccess
}

func removeRepoLock(link: String) -> Int {
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileLOCKPath = filePath + ".lck"
    let fileTMPPath = filePath + ".tmp"
    try? FileManager.default.removeItem(atPath: fileLOCKPath)
    try? FileManager.default.removeItem(atPath: fileTMPPath)
    return returnStatusSuccess
}

func refreshCore(link: String) -> Int {
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileTMPPath = filePath + ".tmp"
    try? FileManager.default.createDirectory(atPath: fileTMPPath, withIntermediateDirectories: true, attributes: nil)
    print("[*] Refreshing repo with link: " + link)
    
    
    
    return returnStatusSuccess
}

func initCheck_dpkg() -> Int {
    
    return returnStatusSuccess
}

public extension UIDevice {
    
    // Detect iOS devices
    // https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

func canOpenURLString(str: String) -> Bool {
    if let url = URL(string: str) {
        if UIApplication.shared.canOpenURL(url) {
            return true
        }
    }
    return false
}

func checkNetwork() -> Void {
    let semaphore = DispatchSemaphore(value: 0)
    NetworkCommonQuene.async {
        let string = try? String.init(contentsOf: URL.init(string: "https://bing.com")!)
        if (string != nil && string != "" ) {
            canTheAppAccessNetWork = true
        }else{
            canTheAppAccessNetWork = false
        }
        semaphore.signal()
    }
    WatchDog.async {
        sleep(3)
        semaphore.signal()
    }
    semaphore.wait()
}
