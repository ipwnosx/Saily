//
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit

class saily_UI_repos_view_controller: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl?.attributedTitle = NSAttributedString(string: "Reload data?", attributes: nil)

    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        self.tableView.reloadData {
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GVAR_behave_repo_list_instance.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return cell
        let idCell = "Cell";
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "theCell")
        if (indexPath.row == 0) {
            cell.textLabel?.text = "        Add New Repo"
            cell.detailTextLabel?.text = "          Saily supports many kinds of repos by tapping here and add them."
            let cellImg = UIImageView(frame: CGRect.init(x: 6, y: 12, width: 38, height: 38))
            cellImg.contentMode = .scaleAspectFit
            cellImg.image = #imageLiteral(resourceName: "iConRound.png")
            cell.addSubview(cellImg)
            cellImg.snp.makeConstraints { (make) in
                make.top.equalTo(cell.contentView).offset(12)
                make.right.equalTo(cell.textLabel!.snp_left).offset(30)
                make.height.equalTo(38)
                make.width.equalTo(38)
            }
            return cell
        }
        // return name
        let name = sco_repos_link_to_name(link: GVAR_behave_repo_list_instance[indexPath.row - 1])
        // return image
        let cellImg = UIImageView(frame: CGRect.init(x: 6, y: 12, width: 38, height: 38))
        cellImg.image = #imageLiteral(resourceName: "iConRound.png")
        sco_Network_return_CydiaIcon(link: GVAR_behave_repo_list_instance[indexPath.row - 1] + "CydiaIcon.png", force_refetch: false) { (image) in
            cellImg.image = image
        }
        cellImg.contentMode = .scaleAspectFit
        cell.addSubview(cellImg)
        // add label
        cell.textLabel?.text = "        " + name
        cell.detailTextLabel?.text = "           " + GVAR_behave_repo_list_instance[indexPath.row - 1]
        cellImg.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView).offset(12)
            make.right.equalTo(cell.textLabel!.snp_left).offset(30)
            make.height.equalTo(38)
            make.width.equalTo(38)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row == 0) {
            return false
        }
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            GVAR_behave_repo_list_instance.remove(at: indexPath.row - 1)
            sco_repos_resave_repo_list()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if (to.row == 0) {
            self.tableView.reloadData()
        }else{
            GVAR_behave_repo_list_instance.swapAt(fromIndexPath.row - 1, to.row - 1)
            sco_repos_resave_repo_list()
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        if (indexPath.row == 0) {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            self.tableView.endEditing(true)
            let alert = UIAlertController(title: "Add Repo", message: "Leave it blank also means to cancel.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = "https://"
                textField.placeholder = "Here -> repo's address."
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                guard var text = textField?.text else {
                    return
                }
                if (!text.hasSuffix("/")) {
                    text += "/"
                }
                GVAR_behave_repo_list_instance.append(text)
                sco_repos_resave_repo_list()
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
