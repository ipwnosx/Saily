//
//  Saily_UI_Sectiosn.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/20.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

class Saily_UI_Sectiosn: UITableViewController {

    var is_root_sections = false
    var data_source = [repo_section_C]()
    
    func push_data_source(d: [repo_section_C]) {
        self.data_source = d
        self.tableView.reloadData()
    }
    
    func set_root_section() {
        self.is_root_sections = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.is_root_sections) {
            return Saily.repos_root.repos.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (is_root_sections) {
            return Saily.repos_root.repos[section].section_root.count
        }
        return self.data_source.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (is_root_sections) {
            return Saily.repos_root.repos[section].name
        }else{
            return nil
        }
    }
    
    var cells_identify_index = 0
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        if (self.is_root_sections) {
            cell.textLabel?.text = Saily.repos_root.repos[indexPath.section].section_root[indexPath.row].name
        }else{
            cell.textLabel?.text = self.data_source[indexPath.row].name
        }
        
        return cell
    }



}
