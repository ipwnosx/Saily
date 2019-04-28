//
//  Saily_UI_Settings.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/24.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

class Saily_UI_Queue: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.dataSource = self
        self.tableview.delegate = self
        
        if (Saily.operation_container.installs.count < 1 && Saily.operation_container.removes.count < 1) {
            self.submit.isEnabled = false
            self.submit.setTitle("Empty".localized(), for: .normal)
            let mafumafu = UIImageView()
            mafumafu.image = #imageLiteral(resourceName: "mafufulove.png")
            mafumafu.contentMode = .scaleAspectFit
            self.view.addSubview(mafumafu)
            mafumafu.snp.makeConstraints { (x) in
                x.bottom.equalTo(self.view.snp.bottom).offset(8)
                x.centerX.equalTo(self.view.snp.centerX)
                x.width.equalTo(128)
                x.height.equalTo(128)
            }
        }
        
        container.snp.makeConstraints { (x) in
            x.top.equalTo(self.view.snp.top)
            x.bottom.equalTo(self.view.snp.bottom)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
        }
        
        submit.snp.makeConstraints { (x) in
            x.top.equalTo(self.view.snp.top).offset(22)
            x.height.equalTo(30)
            x.right.equalTo(self.view.snp.right).offset(-22)
            x.width.equalTo(66)
        }
        
        label.text = "📦 Operations".localized()
        
        label.snp.makeConstraints { (x) in
            x.height.equalTo(48)
            x.left.equalTo(self.view.snp.left).offset(22)
            x.right.equalTo(self.submit.snp.left).offset(-18)
            x.centerY.equalTo(self.submit.snp.centerY)
        }
        
        tableview.snp.makeConstraints { (x) in
            x.top.equalTo(self.label.snp.bottom).offset(18)
            x.bottom.equalTo(self.view.snp.bottom)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
        }
        
        self.tableview.separatorColor = .clear
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if (Saily.operation_container.installs.count > 0) {
            sections += 1
        }
        if (Saily.operation_container.removes.count > 0) {
            sections += 1
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            if (Saily.operation_container.installs.count > 0) {
                return "Install Queue".localized()
            }
        }
        return "Remove Queue".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if (Saily.operation_container.installs.count > 0) {
                return Saily.operation_container.installs.count
            }
        }
        return Saily.operation_container.removes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview.deselectRow(at: indexPath, animated: true)
    }
    
    var cells_identify_index = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        if (indexPath.section == 0) {
            if (Saily.operation_container.installs.count > 0) {
                cell.textLabel?.text = "       " + (Saily.operation_container.installs[indexPath.row].info["NAME"] ?? "No Name Boy".localized())
                cell.detailTextLabel?.text = "         " + (Saily.operation_container.installs[indexPath.row].info["PACKAGE"] ?? "Error: No ID".localized())
            }else{
                cell.textLabel?.text = "       " + (Saily.operation_container.removes[indexPath.row].info["NAME"] ?? "No Name Boy".localized())
                cell.detailTextLabel?.text = "         " + (Saily.operation_container.removes[indexPath.row].info["PACKAGE"] ?? "Error: No ID".localized())
            }
        }else{
            cell.textLabel?.text = "       " + (Saily.operation_container.removes[indexPath.row].info["NAME"] ?? "No Name Boy".localized())
            cell.detailTextLabel?.text = "         " + (Saily.operation_container.removes[indexPath.row].info["PACKAGE"] ?? "Error: No ID".localized())
        }
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tweakIcon.png")
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(14)
            c.right.equalTo(cell.textLabel!.snp.left).offset(22)
            c.width.equalTo(28)
            c.height.equalTo(28)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if (Saily.operation_container.installs.count <= 0 || indexPath.section == 1) {
                Saily.operation_container.removes.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                return
            }
            let alert = UIAlertController(title: "Conform?".localized(), message: "Removing it from queue may be dangerous and may cause dependency(s) missing, which may result a bad install status and is hard to recover. Are you sure you want to remove: \n\n\n".localized() + (tableView.cellForRow(at: indexPath)?.textLabel?.text?.dropFirst(7).description ?? "[E]"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES".localized(), style: .destructive, handler: { (_) in
//                tableView.deleteRows(at: [indexPath], with: .fade)
                if (indexPath.section == 1) {
                    Saily.operation_container.removes.remove(at: indexPath.row)
                }else{
                    if (Saily.operation_container.installs.count <= 0) {
                        Saily.operation_container.removes.remove(at: indexPath.row)
                    }else{
                        Saily.operation_container.installs.remove(at: indexPath.row)
                    }
                }
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel (Recommend)".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
