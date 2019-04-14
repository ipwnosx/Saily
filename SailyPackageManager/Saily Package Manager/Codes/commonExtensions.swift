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
import SwiftyJSON
import SwifterSwift

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
    
    //Clean locks.
    _ = clearAnyLockAndTmp()
    
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
            return returnStatusSuccess
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
    if (!FileManager.default.fileExists(atPath: repoListPath) || FileManager.default.fileExists(atPath: repoListPath + ".lck")) {
        if (initRepo() == returnStatusEPERMIT) {
            return returnStatusEPERMIT
        }
    }
    FileManager.default.createFile(atPath: repoListPath + ".lck", contents: nil, attributes: nil)
    let repoList = try? String.init(contentsOfFile: repoListPath)
    if (repoList == "" || repoList == nil) {
        return returnStatusEPERMIT
    }
    for item in (repoList ?? "").split(separator: "\n") {
        _ = refreshRepoWith(link: item.description)
    }
    try? FileManager.default.removeItem(atPath: repoListPath + ".lck")
    return returnStatusSuccess
}

func refreshRepoWith(link: String) -> Int {
    // repo is in quene, no need to add again.
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileLockPath = filePath + ".lck"
    if (FileManager.default.fileExists(atPath: fileLockPath)) {
        return returnStatusSuccess
    }
    FileManager.default.createFile(atPath: fileLockPath, contents: nil, attributes: nil)
    // sending to back ground quene
    repoRefreshQuene.async {
        _ = lockRepo(link: link)
        _ = refreshCore(link: link)
        _ = removeRepoLock(link: link)
    }
    // always send returnStatusSuccess back because we want to handl error refresh later.
    return returnStatusSuccess
}

func lockRepo(link: String) -> Int {
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileLockPath = filePath + ".lck"
    let fileTempPath = filePath + ".tmp"
    try? FileManager.default.createFile(atPath: fileLockPath, contents: nil, attributes: nil)
    try? FileManager.default.createDirectory(atPath: fileTempPath, withIntermediateDirectories: true, attributes: nil)
    return returnStatusSuccess
}

func removeRepoLock(link: String) -> Int {
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileLockPath = filePath + ".lck"
    let fileTempPath = filePath + ".tmp"
    try? FileManager.default.removeItem(atPath: fileLockPath)
    try? FileManager.default.removeItem(atPath: fileTempPath)
    return returnStatusSuccess
}

func refreshCore(link: String) -> Int {
    guard let url_addr = URL.init(string: link) else {
        return returnStatusEPERMIT
    }
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileTempPath = filePath + ".tmp"
    print("[*] Refreshing repo with link: " + link)
    if (deviceInfo_UDID == "") {
        return returnStatusEPERMIT
    }

    let headers = ["X-Machine" : deviceIdentifier,
                   "X-Unique-ID" : deviceInfo_UDID,
                   "X-Firmware" : deviceVersion,
                   "User-Agent" : "Telesphoreo APT-HTTP/1.0.592"]
    
    Alamofire.request(url_addr, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseString { (str) in
        print(str)
    }

    return returnStatusSuccess
}

func removeRepo(IndexOfLine: Int) -> Int {
    let repoListPath = appRootFileSystem + "/repos/repos.list"
    if (FileManager.default.fileExists(atPath: repoListPath + ".lck")) {
        return returnStatusEPERMIT
    }
    let repos_raw_str = try? String.init(contentsOfFile: repoListPath)
    guard let repo_split = repos_raw_str?.split(separator: "\n") else {
        return returnStatusEPERMIT
    }
    FileManager.default.createFile(atPath: repoListPath + ".lck", contents: nil, attributes: nil)
    let link = repo_split[IndexOfLine]
    let filePath = appRootFileSystem + "/repos/" + link.split(separator: "/")[1]
    let fileLockPath = filePath + ".lck"
    let fileTempPath = filePath + ".tmp"
    if (FileManager.default.fileExists(atPath: fileLockPath)) {
        try? FileManager.default.removeItem(atPath: repoListPath + ".lck")
        return returnStatusEPERMIT
    }
    // Starting remove operation
    FileManager.default.createFile(atPath: fileLockPath, contents: nil, attributes: nil)
    try? FileManager.default.removeItem(atPath: filePath)
    try? FileManager.default.removeItem(atPath: fileTempPath)
    try? FileManager.default.removeItem(atPath: repoListPath)
    // Generate new repo list
    var repo_list_out = ""
    let count: Int! = repo_split.count
    for i in 0..<count {
        if (i != IndexOfLine) {
            repo_list_out = repo_list_out + repo_split[i] + "\n"
        }
    }
    try? repo_list_out.write(toFile: repoListPath, atomically: true, encoding: .utf8)
    try? FileManager.default.removeItem(atPath: repoListPath + ".lck")
    try? FileManager.default.removeItem(atPath: fileLockPath)
    return returnStatusSuccess
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

func initCheck_dpkg() -> Int {
    
    if (checkDeamonAndInitIfAvailable() == returnStatusEPERMIT) {
        return returnStatusEPERMIT
    }
    
    return returnStatusSuccess
}


func checkDeamonAndInitIfAvailable() -> Int {
    
    let unavailable = true
    if (unavailable) {
        return returnStatusEPERMIT
    }
    
    return returnStatusSuccess
}

func clearAnyLockAndTmp() -> Int {
    let rootFiles = try? FileManager.default.contentsOfDirectory(atPath: appRootFileSystem)
    let repoFiles = try? FileManager.default.contentsOfDirectory(atPath: appRootFileSystem + "/repos")
    for items in ((rootFiles ?? []) + (repoFiles ?? [])) {
        if (items.hasSuffix(".lck") || items.hasSuffix(".tmp")) {
            try? FileManager.default.removeItem(atPath: items)
        }
    }
    return returnStatusSuccess
}
