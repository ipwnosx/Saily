//
//  Saily_UI_Settings.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/24.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

import FloatingPanel

class Saily_UI_Settings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var table_view_is_tall: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.dataSource = self
        self.tableview.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table_view_is_tall.constant = self.view.bounds.height * 0.25
        tableview.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Saily.operation_container.returnSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Saily.operation_container.returnSectionName(withIndex: section).localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Saily.operation_container.numbers_in_sections_which_not_empty(withIndexSection: section)
    }
    
    var cells_identify_index = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        cell.textLabel?.text = Saily.operation_container.get_name_of_package(section: indexPath.section, index: indexPath.row)
        
        return cell
    }
}
