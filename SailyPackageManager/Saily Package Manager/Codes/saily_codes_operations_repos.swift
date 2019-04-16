//
//  saily_codes_operations_repos.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/16.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import Foundation

func sco_repos_link_to_name(link: String) -> String {
    var name = link.split(separator: "/")[1].description
    if (name.split(separator: ".").count == 2) {
        name = name.split(separator: ".")[0].description
    }else{
        if (name.split(separator: ".")[0] == "apt" || name.split(separator: ".")[0] == "repo" || name.split(separator: ".")[0] == "cydia") {
            name = name.split(separator: ".")[1].description
        }
    }
    
    name = name.first!.description.uppercased() + name.dropFirst().description
    if (name == "Thebigboss") {
        name = "The Big Boss"
    }
    
    return name
}

func sco_repos_resave_repo_list() -> Void {
    var out = ""
    for item in GVAR_behave_repo_list_instance {
        out = out + item + "\n"
    }
    try? FileManager.default.removeItem(atPath: GVAR_behave_repo_list_file_path)
    try? out.write(toFile: GVAR_behave_repo_list_file_path, atomically: true, encoding: .utf8)
}
