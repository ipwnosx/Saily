//
//  Saily_UI_DiscoverCollectionViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

private let reuseIdentifier = "card"

class Saily_UI_Discover: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collection_view: UICollectionView?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Will Transition to size \(size) from super view size \(self.view.frame.size)")
        
        if (size.width > self.view.frame.size.width) {
            print("Landscape")
        } else {
            print("Portrait")
        }
        if (size.width != self.view.frame.size.width) {
            DispatchQueue.main.async {
//                self.collection_view?.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection_view?.delegate = self
        collection_view?.dataSource = self
        
        // Register cell classes
        collection_view?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Saily.discover_root.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        let whiteBG = UIImageView.init(image: #imageLiteral(resourceName: "WHITE.png"))
        whiteBG.contentMode = .scaleToFill
        cell.contentView.addSubview(whiteBG)
        
        whiteBG.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp_top)
            c.bottom.equalTo(cell.contentView.snp_bottom)
            c.left.equalTo(cell.contentView.snp_left)
            c.right.equalTo(cell.contentView.snp_right)
        }
        
        cell.contentView.layer.cornerRadius = 12.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        if (indexPath.row == 0) {
            let bg = UIImageView()
            bg.image = #imageLiteral(resourceName: "BGBlue.png")
            bg.contentMode = .scaleAspectFill
            cell.contentView.addSubview(bg)
            bg.snp.makeConstraints { (c) in
                c.top.equalTo(cell.contentView.snp_top)
                c.bottom.equalTo(cell.contentView.snp_bottom)
                c.left.equalTo(cell.contentView.snp_left)
                c.right.equalTo(cell.contentView.snp_right)
            }
            var udid_str = ""
            if (!Saily.device.udid_is_true) {
                udid_str += "FAKE: "
            }
            udid_str += Saily.device.udid.description
            let udid_lable = UILabel.init(text: udid_str)
            udid_lable.font = UIFont.systemFont(ofSize: 10)
            udid_lable.textColor = .white
            cell.contentView.addSubview(udid_lable)
            udid_lable.snp.makeConstraints { (c) in
                c.bottom.equalTo(cell.contentView.snp_bottom).offset(-25)
                c.centerX.equalTo(cell.contentView.snp_centerX)
            }
            let main_lable = UILabel.init(text: Saily.device.identifier + " - " + Saily.device.indentifier_human_readable + " - " + Saily.device.version)
            main_lable.textColor = .white
            main_lable.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(main_lable)
            main_lable.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp_centerX)
                c.bottom.equalTo(udid_lable.snp_bottom).offset(-15)
            }
            let welcome_lable = UILabel.init(text: "Welcom to Saily")
            welcome_lable.textColor = .white
            welcome_lable.font = UIFont.systemFont(ofSize: 32)
            cell.contentView.addSubview(welcome_lable)
            welcome_lable.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp_centerX)
                c.centerY.equalTo(cell.contentView.snp_centerY).offset(50)
            }
            let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String) ?? "NAN"
            let buildVersion = (Bundle.main.infoDictionary!["CFBundleVersion"] as? String) ?? "NAN"
            let version_label = UILabel.init(text: "Version: " + appVersion + " Build: " + buildVersion)
            version_label.textColor = .white
            version_label.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(version_label)
            version_label.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp_centerX)
                c.centerY.equalTo(cell.contentView.snp_centerY).offset(80)
            }
            let icon = UIImageView()
            icon.image = #imageLiteral(resourceName: "iConWhiteTransparent.png")
            icon.contentMode = .scaleAspectFit
            cell.contentView.addSubview(icon)
            icon.snp.makeConstraints { (c) in
                c.centerX.equalTo(cell.contentView.snp_centerX)
                c.centerY.equalTo(cell.contentView.snp_centerY).offset(-55)
                c.width.equalTo(128)
                c.height.equalTo(128)
            }
            
            return cell
        }
        
        var content = UIView()
        cell.contentView.addSubview(content)
        
        switch Saily.discover_root[indexPath.row - 1].card_kind {
        case 1:
            content = CardCellKind1()
            (content as? CardCellKind1)?.apart_init(Saily.discover_root[indexPath.row - 1], fater_View: cell.contentView)
        case 2:
            content = CardCellKind2()
            (content as? CardCellKind2)?.apart_init(Saily.discover_root[indexPath.row - 1], fater_View: cell.contentView)
        default:
            content = CardCellKind1()
            (content as? CardCellKind1)?.apart_init(Saily.discover_root[indexPath.row - 1], fater_View: cell.contentView)
        }
        
        cell.addSubview(content)
        content.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp_top)
            c.left.equalTo(cell.contentView.snp_left)
            c.right.equalTo(cell.contentView.snp_right)
            c.bottom.equalTo(cell.contentView.snp_bottom)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let scx = UIScreen.main.bounds.width
        let scy = UIScreen.main.bounds.height
        if (scy > scx) {
            return 50
        }
        return scx / 12
    }
    
}


extension Saily_UI_Discover: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let scx = UIScreen.main.bounds.width
        let scy = UIScreen.main.bounds.height
        
        
        if (Saily.device.indentifier_human_readable.uppercased().contains("iPad".uppercased())) {
            if (scx < scy) {
                return CGSize(width: (scx - 120) / 2, height: 380)
            }
            // land
            switch indexPath.row % 4 {
            case 0, 3:
                return CGSize(width: (scx - 120) / 3 * 2, height: 380)
            case 1, 2:
                return CGSize(width: scx - 240 - (scx - 240) / 3 * 2, height: 380)
            default:
                break
            }
        }
        return CGSize(width: scx - 60, height: 380)
    }
    
    
}
