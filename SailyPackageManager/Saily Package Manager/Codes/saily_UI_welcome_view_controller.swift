//
//  UDIDViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit
import SnapKit

class theCell: UITableViewCell {
    
}

class saily_UI_welcome_view_controller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var default_repos = ["http://apt.thebigboss.org/repofiles/cydia/",
                         "https://apt.bingner.com/",
                         "http://build.frida.re/",
                         "https://repo.chariz.com/",
                         "https://repo.dynastic.co/"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return default_repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return cell
        let idCell = "Cell";
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "theCell")
        // return name
        var name = default_repos[indexPath.row].split(separator: "/")[1].split(separator: ".")[1].description
        name = name.first!.description.uppercased() + name.dropFirst().description
        if (name == "Thebigboss") {
            name = "The Big Boss"
        }
        // return image
        var image = UIImage()
        switch name {
        case "The Big Boss":
            image = #imageLiteral(resourceName: "repo_bigboss.jpg")
        case "Bingner":
            image = #imageLiteral(resourceName: "repo_bingner.png")
        default:
            break
        }
        // add image view
        let cellImg : UIImageView = UIImageView(frame: CGRect.init(x: 6, y: 12, width: 38, height: 38))
        cellImg.image = image
        cellImg.contentMode = .scaleAspectFit
        cell.addSubview(cellImg)
        // add label
        cell.textLabel?.text = "        " + name
        cell.detailTextLabel?.text = "           " + default_repos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var big_title: UILabel!
    @IBOutlet weak var small_title: UILabel!
    @IBOutlet weak var query_text: UILabel!
    @IBOutlet weak var udid_tip_title: UILabel!
    @IBOutlet weak var udid_text_field: UITextField!
    @IBOutlet weak var generate_button: UIButton!
    @IBOutlet weak var get_button: UIButton!
    @IBOutlet weak var repo_title: UILabel!
    @IBOutlet weak var repo_sub_title: UILabel!
    @IBOutlet weak var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenX = UIScreen.main.bounds.width
        let screenY = UIScreen.main.bounds.height
        
        table_view.delegate = self
        table_view.dataSource = self
        
        guard let this_view = self.view else { return }
        if (GVAR_device_info_identifier_human_readable.contains("iPhone")) {
            // iPhone layout
            icon.snp.makeConstraints { (make) in
                make.top.equalTo(this_view).offset(66)
                if (screenX > 320) {
                    make.left.equalTo(this_view).offset(25)
                }else{
                    make.left.equalTo(this_view).offset(15)
                }
                make.width.equalTo(88)
                make.height.equalTo(88)
            }
            big_title.snp.makeConstraints { (make) in
                make.left.equalTo(icon).offset(icon.width + 20)
                make.top.equalTo(icon).offset(22)
                make.width.equalTo(172)
                make.height.equalTo(33)
            }
            small_title.snp.makeConstraints { (make) in
                make.centerX.equalTo(big_title)
                make.top.equalTo(big_title).offset(big_title.height + 11)
                make.width.equalTo(207)
                make.height.equalTo(19)
            }
            query_text.snp.makeConstraints { (make) in
                make.top.equalTo(icon).offset(icon.height + 20)
                make.left.equalTo(this_view).offset(28)
                make.right.equalTo(this_view).offset(-28)
                make.height.equalTo(70)
            }
            udid_tip_title.snp.makeConstraints { (make) in
                make.top.equalTo(query_text).offset(query_text.height + 28)
                make.left.equalTo(this_view).offset(28)
                make.width.equalTo(255)
                make.height.equalTo(22)
            }
            udid_text_field.snp.makeConstraints { (make) in
                make.top.equalTo(udid_tip_title).offset(udid_tip_title.height + 8)
                make.left.equalTo(this_view).offset(28)
                make.right.equalTo(this_view).offset(-28)
                make.height.equalTo(25)
            }
            generate_button.snp.makeConstraints { (make) in
                make.top.equalTo(udid_text_field).offset(udid_text_field.height + 8)
                make.left.equalTo(this_view).offset(30)
                make.width.equalTo(73)
                make.height.equalTo(25)
            }
            get_button.snp.makeConstraints { (make) in
                make.top.equalTo(udid_text_field).offset(udid_text_field.height + 8)
                make.left.equalTo(generate_button).offset(generate_button.width + 28)
                make.right.equalTo(this_view).offset(-30)
                make.height.equalTo(25)
            }
            repo_title.snp.makeConstraints { (make) in
                make.top.equalTo(generate_button).offset(generate_button.height + 28)
                make.left.equalTo(this_view).offset(28)
                make.width.equalTo(250)
                make.height.equalTo(25)
            }
            repo_sub_title.snp.makeConstraints { (make) in
                make.top.equalTo(repo_title).offset(repo_title.height + 8)
                make.left.equalTo(this_view).offset(28)
                make.width.equalTo(250)
                make.height.equalTo(25)
            }
            table_view.snp.makeConstraints { (make) in
                make.top.equalTo(repo_sub_title).offset(repo_sub_title.height + 18)
                make.left.equalTo(this_view).offset(28)
                make.right.equalTo(this_view).offset(-28)
                make.bottom.equalTo(this_view).offset(-66)
            }
        }else{
            // iPad layout
            
        }
        

    }
    
    

    
}
