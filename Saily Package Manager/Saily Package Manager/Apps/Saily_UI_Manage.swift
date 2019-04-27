//
//  Saily_UI_Manage.swift
//  
//
//  Created by Lakr Aream on 2019/4/21.
//

import UIKit

class Saily_UI_Manage: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var data_source = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_source.count
    }
    
    var cells_identify_index = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        if (indexPath.row > data_source.count - 1) {
            return cell
        }
        DispatchQueue.main.async {
            if let this_package = Saily.search_a_package_with(its_name: self.data_source[indexPath.row].split(separator: " ")[1].description) {
                if let name = this_package.info["NAME"] {
                    cell.textLabel?.text = "         " + name
                }else{
                    if let name2 = this_package.info["PACKAGE"] {
                        cell.textLabel?.text = "         " + name2
                    }
                }
                if let des = this_package.info["DESCRIPTION"] {
                    cell.detailTextLabel?.text = "            " + des
                }
            }
        }
        cell.textLabel?.text = "         " + data_source[indexPath.row].split(separator: " ")[1].description
        if (data_source[indexPath.row].split(separator: " ").count >= 3) {
            var index = 0
            var read = ""
            for item in data_source[indexPath.row].split(separator: " ") {
                if (index < 3) {
                    index += 1
                }else{
                    read = read + " " + item.description
                }
            }
            cell.detailTextLabel?.text = "            " + read.dropFirst().description
        }else{
            cell.detailTextLabel?.text = "            " + "No description found within the database.".localized()
        }
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tweakIcon.png")
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(14)
            c.right.equalTo(cell.textLabel!.snp.left).offset(26)
            c.width.equalTo(28)
            c.height.equalTo(28)
        }
        let next = UIImageView()
        next.image = #imageLiteral(resourceName: "next.png")
        cell.addSubview(next)
        next.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(23)
            c.right.equalTo(cell.snp.right).offset(-16)
            c.width.equalTo(14)
            c.height.equalTo(14)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let package = Saily.search_a_package_with(its_name: data_source[indexPath.row].split(separator: " ")[1].description) {
            let storyboard_ins = UIStoryboard(name: "Main", bundle: nil)
            
            //        if (package.info["SileoDepiction".uppercased()] != nil && package.info["SileoDepiction".uppercased()] != "") {
            //            let sb = storyboard_ins.instantiateViewController(withIdentifier: "Saily_UI_Tweak_Native_ID") as? Saily_UI_Tweak_Native
            //            sb?.this_package = package
            //            self.navigationController?.pushViewController(sb!)
            //            print("[*] Pushing to native controller.")
            //            return
            //        }
            let sb = storyboard_ins.instantiateViewController(withIdentifier: "Saily_UI_Tweak_Webkit_ID") as? Saily_UI_Tweak_Webkit
            sb?.this_package = package
            self.navigationController?.pushViewController(sb!)
            print("[*] Pushing to WebKit controller.")
        }
    }
    
    let dangerous_packages = ["virtual GraphicsServices dependency",
                              "UIKit/GraphicsServices command line access",
                              ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Saily.manage_UI = self
        
        if (Saily.daemon_online) {
            if let dpkgread = Saily_FileU.simple_read(Saily.files.daemon_root + "/dpkgl.out") {
                let splited = dpkgread.split(separator: "\n").dropFirst(5)
                for item in splited {
                    var is_dangerous = false
                    for i in dangerous_packages {
                        if (item.description.uppercased().contains(i.uppercased())) {
                            is_dangerous = true
                        }
                    }
                    if (is_dangerous) {
                        // DANGEROUS PACKAGE
                    }else{
                        self.data_source.append(item.description)
                    }
                    Saily.installed.append(item.split(separator: " ")[1].description)
                }
            }
        }else{
            self.tableView.separatorColor = .clear
            let image = UIImageView.init(image: #imageLiteral(resourceName: "mafumafu_dead_rul.png"))
            image.contentMode = .scaleAspectFit
            self.view.addSubview(image)
            image.snp.makeConstraints { (x) in
                x.center.equalTo(self.view)
                x.width.equalTo(128)
                x.height.equalTo(128)
            }
            let non_connection = UILabel.init(text: "Error: - 0xbadacce44dae880\nBAD LAUNCH DAEMON STATUS")
            non_connection.textColor = .gray
            non_connection.numberOfLines = 2
            non_connection.textAlignment = .center
            non_connection.font = .boldSystemFont(ofSize: 12)
            self.view.addSubview(non_connection)
            non_connection.snp.makeConstraints { (x) in
                x.centerX.equalTo(self.view.snp.centerX)
                x.top.equalTo(image.snp.bottom).offset(28)
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading data(s)...".localized(), attributes: nil)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func refreshData(_ sender: Any) {
        Saily.operation_quene.wrapper_queue.asyncAfter(deadline: .now() + 0.3) {
            let ss = DispatchSemaphore(value: 0)
            DispatchQueue.main.async {
                UIApplication.shared.beginIgnoringInteractionEvents()
                ss.signal()
            }
            ss.wait()
            try? FileManager.default.removeItem(atPath: Saily.files.daemon_root + "/dpkgl.out")
            if (!Saily.daemon_online) {
                XPC_ins.tell_demon_to_listen_at_port()
            }
            Saily.objc_bridge.callToDaemon(with: "com.Saily.list_dpkg")
            let s = DispatchSemaphore(value: 0)
            Saily.operation_quene.network_queue.asyncAfter(deadline: .now() + 1) {
                if let dpkgread = Saily_FileU.simple_read(Saily.files.daemon_root + "/dpkgl.out") {
                    print("\n\n\n[*] Daemon online~~ yayayayaa!")
                    print("[*] START DPKG STATUS ---------------------------------------")
                    print(dpkgread)
                    Saily.daemon_online = true
                    print("[*] END DPKG STATUS ---------------------------------------\n\n\n")
                }else{
                    Saily.daemon_online = false
                }
                s.signal()
            }
            s.wait()
            self.data_source = [String]()
            if (Saily.daemon_online) {
                if let dpkgread = Saily_FileU.simple_read(Saily.files.daemon_root + "/dpkgl.out") {
                    let splited = dpkgread.split(separator: "\n").dropFirst(5)
                    for item in splited {
                        var is_dangerous = false
                        for i in self.dangerous_packages {
                            if (item.description.uppercased().contains(i.uppercased())) {
                                is_dangerous = true
                            }
                        }
                        if (is_dangerous) {
                            // DANGEROUS PACKAGE
                        }else{
                            self.data_source.append(item.description)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if (Saily.daemon_online) {
                    self.tableView.separatorColor = .lightGray
                }else{
                    self.tableView.separatorColor = .clear
                    
                    for item in self.view.subviews {
                        if let image = item as? UIImageView{
                            image.removeSubviews()
                        }
                        if let label = item as? UILabel {
                            label.removeSubviews()
                        }
                    }
                    
                    self.tableView.separatorColor = .clear
                    let image = UIImageView.init(image: #imageLiteral(resourceName: "mafumafu_dead_rul.png"))
                    image.contentMode = .scaleAspectFit
                    self.view.addSubview(image)
                    image.snp.makeConstraints { (x) in
                        x.center.equalTo(self.view)
                        x.width.equalTo(128)
                        x.height.equalTo(128)
                    }
                    let non_connection = UILabel.init(text: "Error: - 0xbadacce44dae880\nBAD LAUNCH DAEMON STATUS")
                    non_connection.textColor = .gray
                    non_connection.numberOfLines = 2
                    non_connection.textAlignment = .center
                    non_connection.font = .boldSystemFont(ofSize: 12)
                    self.view.addSubview(non_connection)
                    non_connection.snp.makeConstraints { (x) in
                        x.centerX.equalTo(self.view.snp.centerX)
                        x.top.equalTo(image.snp.bottom).offset(28)
                    }
                }
                UIApplication.shared.endIgnoringInteractionEvents()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
}
