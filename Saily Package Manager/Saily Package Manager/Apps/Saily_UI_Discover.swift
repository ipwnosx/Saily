//
//  Saily_UI_DiscoverCollectionViewController.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cards"

class Saily_UI_Discover: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collection_view: UICollectionView?
    @IBOutlet weak var no_responed_delegate: UIImageView!

    
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
                self.collection_view?.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection_view?.delegate = self
        collection_view?.dataSource = self
        
        self.view.layoutIfNeeded()
        self.collection_view?.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.no_responed_delegate.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Saily.discover_root.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
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
        
        for item in cell.contentView.subviews {
            item.removeFromSuperview()
        }
        
        let whiteBG = UIImageView.init(image: #imageLiteral(resourceName: "WHITE.png"))
        whiteBG.contentMode = .scaleToFill
        cell.contentView.addSubview(whiteBG)
        
        whiteBG.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp_top)
            c.bottom.equalTo(cell.contentView.snp_bottom)
            c.left.equalTo(cell.contentView.snp_left)
            c.right.equalTo(cell.contentView.snp_right)
        }
        
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
        
        Saily.discover_root[indexPath.row - 1].reg_content_view(content)
        
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
        return scx / 18
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let new = Saily_UI_Discover_Detail()
        if (indexPath.row == 0) {
            new.title = "Welcome"
            let main_view = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: UIScreen.main.bounds.width / 1280 * 640))
            let bg = UIImageView()
            bg.image = #imageLiteral(resourceName: "SocialPreview.png")
            bg.contentMode = .scaleAspectFit
            bg.clipsToBounds = true
            main_view.addSubview(bg)
            bg.snp.makeConstraints { (c) in
                c.top.equalTo(main_view.snp_top)
                c.bottom.equalTo(main_view.snp_bottom)
                c.left.equalTo(main_view.snp_left)
                c.right.equalTo(main_view.snp_right)
            }
            new.objects.append(main_view)
            let newww = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 80))
            let title = UITextView()
            title.text = "Settings"
            title.textColor = .darkGray
            title.font = .boldSystemFont(ofSize: 30)
            title.isEditable = false
            newww.addSubview(title)
            title.snp.makeConstraints { (c) in
                c.left.equalTo(newww.snp_left).offset(15)
                c.right.equalTo(newww.snp_right).offset(-20)
                c.top.equalTo(newww.snp_top).offset(20)
                c.bottom.equalTo(newww.snp_bottom).offset(-15)
            }
            new.objects.append(newww)
            let newwwwww = UIImageView()
            newww.addSubview(newwwwww)
            newwwwww.snp.makeConstraints { (c) in
                c.top.equalTo(title.snp_top)
                c.left.equalTo(title.snp_left)
                c.bottom.equalTo(title.snp_bottom)
                c.right.equalTo(title.snp_right)
            }
            newwwwww.isUserInteractionEnabled = true
        }else{
            new.discover_item = Saily.discover_root[indexPath.row - 1]
            new.title = "Details"
            let main_view = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 320))
            let bg = UIImageView()
            let temp = CardCellKind1()
            guard let image = temp.return_cached_image(link: Saily.discover_root[indexPath.row - 1].image_link) else {
                return
            }
            bg.image = image
            bg.contentMode = .scaleAspectFill
            bg.clipsToBounds = true
            main_view.addSubview(bg)
            bg.snp.makeConstraints { (c) in
                c.top.equalTo(main_view.snp_top)
                c.bottom.equalTo(main_view.snp_bottom)
                c.left.equalTo(main_view.snp_left)
                c.right.equalTo(main_view.snp_right)
            }
            new.objects.append(main_view)
            let newww = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
            let title = UITextView()
            title.text = Saily.discover_root[indexPath.row - 1].title_big
            title.textColor = .darkGray
            title.font = .boldSystemFont(ofSize: 30)
            title.isEditable = false
            newww.addSubview(title)
            title.snp.makeConstraints { (c) in
                c.left.equalTo(newww.snp_left).offset(15)
                c.right.equalTo(newww.snp_right).offset(-20)
                c.top.equalTo(newww.snp_top).offset(20)
                c.bottom.equalTo(newww.snp_bottom).offset(-15)
            }
            new.objects.append(newww)
            let newwwwww = UIImageView()
            newww.addSubview(newwwwww)
            newwwwww.snp.makeConstraints { (c) in
                c.top.equalTo(title.snp_top)
                c.left.equalTo(title.snp_left)
                c.bottom.equalTo(title.snp_bottom)
                c.right.equalTo(title.snp_right)
            }
            newwwwww.isUserInteractionEnabled = true
            if (Saily.discover_root[indexPath.row - 1].tweak_id != "" && Saily.discover_root[indexPath.row - 1].tweak_id != "") {
                let tweakView = PackageDownloadView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 233))
                tweakView.name.text = Saily.discover_root[indexPath.row - 1].tweak_id
                tweakView.apart_init()
                new.objects.append(tweakView)
            }
        }
        self.navigationController?.pushViewController(new)
        
    }
    
}


extension Saily_UI_Discover: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let scx = UIScreen.main.bounds.width
        let scy = UIScreen.main.bounds.height
        
        if (scy < 600 && scx < 350) {
            return CGSize(width: scx - 20, height: 420)
        }
        
        if (Saily.device.indentifier_human_readable.uppercased().contains("iPad".uppercased())) {
            if (scx < scy) {
                return CGSize(width: (scx - 120) / 2, height: 380)
            }
            // land
            switch indexPath.row % 4 {
            case 0, 3:
                return CGSize(width: scx * 5.2 / 10, height: 380)
            case 1, 2:
                return CGSize(width: scx * 3.6 / 10, height: 380)
            default:
                break
            }
        }
        return CGSize(width: scx - 60, height: 380)
    }
    
    
}
