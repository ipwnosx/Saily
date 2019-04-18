//
//  saily_UI_repos_sections_view_controller.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/18.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit

class saily_UI_repos_sections_view_controller: UITableViewController {
    
    var sections_data = [repo_section_ins]()
    
    func put_data(d: [repo_section_ins]) -> Void {
        sections_data = d
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections_data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "theCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) ?? UITableViewCell.init(style: .value1, reuseIdentifier: "theCell")
        
        cell.textLabel?.text = sections_data[indexPath.row].name
        cell.detailTextLabel?.text = sections_data[indexPath.row].packages.count.description + " ->"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let packages_view_controller = saily_UI_repos_packages_view_controller()
        packages_view_controller.push_data(d: sections_data[indexPath.row].packages)
        self.navigationController?.pushViewController(packages_view_controller)
    }
    
    
}
