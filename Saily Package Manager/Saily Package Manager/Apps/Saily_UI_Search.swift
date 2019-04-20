//
//  Saily_UI_Search.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/20.
//  Copyright © 2019 Lakr233. All rights reserved.
//

//
//  Saily_UI_Packages.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/20.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit


class Saily_UI_Search: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    private var in_search = false
    private var container = [packages_C]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mySearchcontroller = UISearchController(searchResultsController: nil)
        mySearchcontroller.obscuresBackgroundDuringPresentation = false
        mySearchcontroller.searchBar.placeholder = "Search"
        mySearchcontroller.searchBar.delegate = self
        mySearchcontroller.hidesBottomBarWhenPushed = false
        definesPresentationContext = true
        self.navigationItem.searchController = mySearchcontroller
        
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        self.tableView.reloadData()
        return
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            container.removeAll()
            self.tableView.reloadData()
            return
        }
        var index = 0
        self.container = Saily.root_packages
        for item in self.container {
            if (!(item.info["Package".uppercased()]?.uppercased().contains(searchText.uppercased()) ?? false)
                && !(item.info["Name".uppercased()]?.uppercased().contains(searchText.uppercased()) ?? false)) {
                container.remove(at: index)
            }else{
                index += 1
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return container.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // find us a cell
        let idCell = "theCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "theCell")
        
        print("[*] The PACKAGE is: " + (container[indexPath.row].info["Package".uppercased()] ?? "") + " | " + (container[indexPath.row].info["Name".uppercased()] ?? ""))
        
        if (container[indexPath.row].info["Name".uppercased()] == nil || container[indexPath.row].info["Name".uppercased()] == "") {
            cell.textLabel?.text = "         " + (container[indexPath.row].info["Package".uppercased()] ?? "")
        }else{
            cell.textLabel?.text = "         " + (container[indexPath.row].info["Name".uppercased()] ?? "")
        }
        cell.detailTextLabel?.text = "            " + (container[indexPath.row].info["FILENAME".uppercased()] ?? "")
        cell.detailTextLabel?.textColor = .lightGray
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tweakIcon.png")
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp_top).offset(14)
            c.right.equalTo(cell.textLabel!.snp_left).offset(26)
            c.width.equalTo(28)
            c.height.equalTo(28)
        }
        let next = UIImageView()
        next.image = #imageLiteral(resourceName: "next.png")
        cell.addSubview(next)
        next.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp_top).offset(23)
            c.right.equalTo(cell.snp_right).offset(-16)
            c.width.equalTo(14)
            c.height.equalTo(14)
        }
        
        return cell
    }
    
    
}
