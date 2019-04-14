//
//  SecondViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/13.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit

class sourcesViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    var sourceList = [String?]()
    
    var repoCacheRootFilePath = String()
    var repoListFilePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoCacheRootFilePath = appRootFileSystem + "/repos"
        repoListFilePath = repoCacheRootFilePath + "/repos.list"
        let source_raw_list: String! = try! String.init(contentsOfFile: repoListFilePath)
        for repos in source_raw_list.split(separator: "\n") {
            sourceList.append(repos.description)
        }
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
    }
    
    


}

