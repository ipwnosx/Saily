//
//  Saily_UI_Repos.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/20.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

import SnapKit
import SwifterSwift
import MKRingProgressView

class Saily_UI_Repos: UITableViewController {

    var manually_refreseh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.title = "Edit"
        
        let add_button = UIBarButtonItem.init(title: "Add", style: .plain, target: self, action: Selector(("didTapAddButton")))
        
        navigationItem.rightBarButtonItems = [add_button]
        self.tableView.separatorColor = .clear
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl?.attributedTitle = NSAttributedString(string: "Reloading data(s)...", attributes: nil)
        
    }

    @objc func refreshData(_ sender: Any) {
        Saily.repos_root.refresh_call()
        self.refreshControl?.endRefreshing()
    }
    
    @objc func didTapAddButton() {
        
        if (Saily.copy_board_can_use) {
            let alert = UIAlertController.init(title: "Copy Board contains URL", message: "Do you want to add this url as a repo?\n\n" + Saily.copy_board, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (_) in
                if (!Saily.copy_board.hasSuffix("/")) {
                    Saily.copy_board += "/"
                }
                for item in Saily.repos_root.repos {
                    if (item.ress.major == Saily.copy_board) {
                        UIPasteboard.general.setValue("", forPasteboardType: "")
                        Saily.copy_board = ""
                        Saily.copy_board_can_use = false
                        return
                    }
                }
                Saily.repos_root.repos.append(a_repo(ilink: Saily.copy_board))
                Saily.repos_root.resave()
                UIPasteboard.general.setValue("", forPasteboardType: "")
                Saily.copy_board = ""
                Saily.copy_board_can_use = false
                self.tableView.reloadData()
                return
            }))
            alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: { (_) in
            }))
            self.present(alert, animated: true) {
            }
        }
        var read = ""
        let alert = UIAlertController.init(title: "Add Repo", message: "Enter the link of the repo", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "https://"
        }
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            read = textField?.text ?? ""
            if (URL.init(string: read) != nil) {
                if (!read.hasSuffix("/")) {
                    read += "/"
                }
                for item in Saily.repos_root.repos {
                    if (item.ress.major == read) {
                        UIPasteboard.general.setValue("", forPasteboardType: "")
                        Saily.copy_board = ""
                        Saily.copy_board_can_use = false
                        return
                    }
                }
                Saily.repos_root.repos.append(a_repo(ilink: read))
                Saily.repos_root.resave()
                self.tableView.reloadData()
            }else{
                let alert = UIAlertController.init(title: "Error", message: "This is not an URL, retry?", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
                    self.didTapAddButton()
                }))
                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in
                    return
                }))
                self.present(alert, animated: true) {
                }
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in
            return
        }))
        self.present(alert, animated: true) {
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Saily.repos_root.repos.count + 2
    }

    var cells_identify_index = 0
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "All Packages"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.detailTextLabel?.text = "See all packages from your sources"
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            cell.separatorInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let next = UIImageView()
            next.image = #imageLiteral(resourceName: "next.png")
            cell.addSubview(next)
            next.snp.makeConstraints { (c) in
                c.top.equalTo(cell.contentView.snp_top).offset(23)
                c.right.equalTo(cell.snp_right).offset(-16)
                c.width.equalTo(14)
                c.height.equalTo(14)
            }
        case 1:
            cell.textLabel?.text = "All My Repos"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            cell.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        default:
            cell.textLabel?.text = "         " + Saily.repos_root.repos[indexPath.row - 2].name
            cell.detailTextLabel?.text = "            " + Saily.repos_root.repos[indexPath.row - 2].ress.major
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            cell.separatorInset = UIEdgeInsets(top: 18, left: 0, bottom: 10, right: 0)
            let imageView = UIImageView()
            imageView.setRadius(radius: 8)
            Saily.repos_root.repos[indexPath.row - 2].exposed_icon_image = imageView
            Saily.repos_root.repos[indexPath.row - 2].table_view_init_call {
            }
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { (c) in
                c.top.equalTo(cell.contentView.snp_top).offset(10)
                c.right.equalTo(cell.textLabel!.snp_left).offset(30)
                c.width.equalTo(36)
                c.height.equalTo(36)
            }
            let next = UIImageView()
            next.image = #imageLiteral(resourceName: "next.png")
            cell.addSubview(next)
            next.snp.makeConstraints { (c) in
                c.top.equalTo(cell.contentView.snp_top).offset(23)
                c.right.equalTo(cell.contentView.snp_right).offset(-16)
                c.width.equalTo(14)
                c.height.equalTo(14)
            }
            let progressView = UIProgressView()
            progressView.progress = 0.0
            Saily.repos_root.repos[indexPath.row - 2].set_exposed_progress_view(progressView)
            progressView.trackTintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            cell.addSubview(progressView)
            progressView.snp.makeConstraints { (c) in
                c.bottom.equalTo(cell.contentView.snp_bottom).offset(0 - progressView.bounds.height)
                c.left.equalTo(cell.textLabel!.snp_left).offset(40)
                c.right.equalTo(cell.contentView.snp_right).offset(0)
                c.height.equalTo(1)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var ret = CGFloat()
        switch indexPath.row {
        case 0:
            ret = 58
        case 1:
            ret = 45
        default:
            ret = 58
        }
        return ret
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row >= 0 && indexPath.row <= 1) {
            return false
        }
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Saily.repos_root.repos.remove(at: indexPath.row - 2)
            Saily.repos_root.resave()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if (fromIndexPath.row == to.row) {
            return
        }
        if (to.row >= 0 && to.row <= 1) {
            self.tableView.reloadData()
        }else{
            let repo = Saily.repos_root.repos[fromIndexPath.row - 2]
            Saily.repos_root.repos.remove(at: fromIndexPath.row - 2)
            Saily.repos_root.repos.insert(repo, at: to.row - 2)
            Saily.repos_root.resave()
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if (indexPath.row >= 0 && indexPath.row <= 1) {
            return false
        }
        return true
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let section_vc = Saily_UI_Sectiosn()
            section_vc.set_root_section()
            self.navigationController?.pushViewController(section_vc)
        case 1:
            break
        default:
            let section_vc = Saily_UI_Sectiosn()
            var new = [repo_section_C]()
            for item in Saily.repos_root.repos[indexPath.row - 2].section_root {
                new.append(item)
            }
            section_vc.push_data_source(d: new)
            section_vc.set_title(title: Saily.repos_root.repos[indexPath.row - 2].name)
            self.navigationController?.pushViewController(section_vc)
        }
    }

}

