//
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import MKRingProgressView

class saily_UI_repos_view_controller: UITableViewController {

    var force_refetch = false
    var timer = Timer()
    
    // Heartbeat to init progress view.
    func firstTimer() -> Void {
        timer = Timer.init(timeInterval: 1, repeats:true) { (kTimer) in
            self.progress_update()
        }
        RunLoop.current.add(timer, forMode: .default)
        timer.fire()
    }
    
    func progress_update() -> Void {
        var index = 0
        for cell in self.tableView.visibleCells.dropFirst() {
            for v in cell.subviews {
                if (v.tag == 666) {
                    let b = v as! RingProgressView
                    let value = GVAR_behave_repo_instance[index].progress
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.38, animations: {
                            b.progress = value
                        })
                    }
                    if (b.progress == 0 || b.progress == 1.0) {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.2, animations: {
                                b.alpha = 0
                            })
                        }
                    }else{
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.2, animations: {
                                b.alpha = 1
                            })
                        }
                    }
                }
            }
            index += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTimer()
        
        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl?.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl?.attributedTitle = NSAttributedString(string: "Reload data?", attributes: nil)

    }
    
    @objc private func refreshData(_ sender: Any) {
        force_refetch = true
        self.tableView.reloadData {
            self.force_refetch = false
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GVAR_behave_repo_instance.count + 1
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
        // set image
        let cellImg = UIImageView(frame: CGRect.init(x: 6, y: 12, width: 38, height: 38))
        cellImg.image = GVAR_behave_repo_instance[indexPath.row - 1].icon_img
        cellImg.contentMode = .scaleAspectFit
        cell.addSubview(cellImg)
        // add label
        cell.textLabel?.text = "        " + GVAR_behave_repo_instance[indexPath.row - 1].name
        cell.detailTextLabel?.text = "           " + GVAR_behave_repo_instance[indexPath.row - 1].links.major
        cellImg.snp.makeConstraints { (make) in
            make.top.equalTo(cell.contentView).offset(12)
            make.right.equalTo(cell.textLabel!.snp_left).offset(30)
            make.height.equalTo(38)
            make.width.equalTo(38)
        }
        let progressInd = RingProgressView.init()
        progressInd.startColor = UIColor.init(hex: 0x619AC3)!
        progressInd.endColor = UIColor.init(hex: 0x619AC3)!
        progressInd.ringWidth = 2
        progressInd.progress = GVAR_behave_repo_instance[indexPath.row - 1].progress
        progressInd.tag = 666
        if (progressInd.progress == 0.0 || progressInd.progress == 1.0) {
            progressInd.alpha = 0
            progressInd.progress = 0
        }
        cell.addSubview(progressInd)
        progressInd.snp.makeConstraints { (make) in
            make.height.equalTo(23)
            make.width.equalTo(23)
            make.right.equalTo(cell.snp_right).offset(0 - progressInd.width - 18)
            make.centerY.equalTo(cell.snp_centerY).offset(0)
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
            GVAR_behave_repo_instance.remove(at: indexPath.row - 1)
            sco_repos_resave_repos_list()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if (to.row == 0) {
            self.tableView.reloadData()
        }else{
            print("[*] Remapping table view at index: " + (fromIndexPath.row - 1).description + ", " + (to.row - 1).description)
            GVAR_behave_repo_instance.removeAll()
            for cell in self.tableView.visibleCells.dropFirst() {
                GVAR_behave_repo_instance.append(repo(major_link: cell.detailTextLabel?.text?.dropFirst("            ".count).description ?? ""))
            }
            sco_repos_resave_repos_list()
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
                GVAR_behave_repo_instance.append(repo(major_link: text))
                sco_repos_resave_repos_list()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.tableView.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
