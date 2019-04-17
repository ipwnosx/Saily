//
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

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

func sco_File_decompress(file_path: String, completionHandler: @escaping (_ ret: Int) -> ()) {
    print("[*] Starting sco_File_decompress with file at: " + file_path)
    guard let backend = file_path.split(separator: ".").last else { completionHandler(rts_EPERMIT); return }
    let url0 = URL.init(fileURLWithPath: file_path)
    guard let data = try? Data.init(contentsOf: url0) else { completionHandler(rts_EPERMIT); return }
    var ret_data : Data? = nil
    switch backend {
    case "none":
        completionHandler(rts_EPERMIT)
        return
    case "bz":
        ret_data = const_objc_bridge_object.unBzip(data)
        break
    case "gz":
        ret_data = const_objc_bridge_object.unGzip(data)
        break
    case "bz2":
        ret_data = const_objc_bridge_object.unBzip(data)
        break
    case "gz2":
        ret_data = const_objc_bridge_object.unGzip(data)
        break
    default:
        completionHandler(rts_EPERMIT)
        return
    }
    if (ret_data == nil) {
        print("[E] Error while sco_File_decompress at: " + file_path)
        completionHandler(rts_EPERMIT)
        return
    }
    FileManager.default.createFile(atPath: file_path + ".out", contents: ret_data, attributes: nil)
    print("[*] ended sco_File_decompress: " + file_path)
    completionHandler(rts_SUCCESS)
}
