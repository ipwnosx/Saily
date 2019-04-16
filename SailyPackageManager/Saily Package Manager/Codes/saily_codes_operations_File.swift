//
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import SWCompression    // https://github.com/tsolomko/SWCompression

func sco_File_remove_any_lck_file_at_main_and_repo() -> Void {
    let rootFiles = try? FileManager.default.contentsOfDirectory(atPath: GVAR_behave_app_root_file_path)
    let repoFiles = try? FileManager.default.contentsOfDirectory(atPath: GVAR_behave_app_root_file_path + "/repos")
    for items in ((rootFiles ?? []) + (repoFiles ?? [])) {
        if (items.hasSuffix(".lck") || items.hasSuffix(".tmp")) {
            try? FileManager.default.removeItem(atPath: items)
        }
    }
}

func sco_File_make_sure_file_at(path: String, isDirect: Bool) -> Void {
    if (FileManager.default.fileExists(atPath: path)) {
        return
    }
    if (isDirect) {
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }else{
        FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }
}
