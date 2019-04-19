//
//  OperatorsClass.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation

let Saily_FileU = Saily_File_Unit()
class Saily_File_Unit {
    func exists(file_path: String) -> Bool {
        return FileManager.default.fileExists(atPath: file_path)
    }
    func simple_read(_ file_path: String) -> String? {
        let url0 = URL.init(fileURLWithPath: file_path)
        guard let data = try? Data.init(contentsOf: url0) else { return nil }
        var ret: String? = nil
        ret = String.init(data: data, encoding: .utf8)
        if (ret != "" && ret != nil) {
            return ret
        }
        ret = String.init(data: data, encoding: .ascii)
        if (ret != "" && ret != nil) {
            return ret
        }
        return nil
    }
    func simple_write(file_path: String, file_content: String) {
        if (FileManager.default.fileExists(atPath: file_path)) {
            try? FileManager.default.removeItem(atPath: file_path)
        }
        FileManager.default.createFile(atPath: file_path, contents: nil, attributes: nil)
        try? file_content.write(toFile: file_path, atomically: true, encoding: .utf8)
    }
}
