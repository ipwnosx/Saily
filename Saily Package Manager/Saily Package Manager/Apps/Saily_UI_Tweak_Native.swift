//
//  Saily_UI_Tweak_Native.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/22.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

private let reuseIdentifier = "images"

class Saily_UI_Tweak_Native: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    

    public var this_package: packages_C? = nil
    @IBOutlet weak var container: UIScrollView!
    
    var Area1_Package_Icon = UIImageView()
    var Area1_Package_Name = UILabel()
    var Area1_Package_ID = UILabel()
    var Area1_Add_Queue_Button = UIButton()
    var Area1_Share_Button = UIButton()
    var Area1_Separator = UIView()
    
    var Area2_Whats_New = UILabel()
    var Area2_Version = UILabel()
    var Area2_Description = UILabel()
    var Area2_Separator = UIView()
    
    var Area3_Preview = UILabel()
    var Area3_Images = UICollectionView.init(frame: CGRect(x: 0,y: 0,width: 0,height: 0), collectionViewLayout: UICollectionViewLayout.init())
    var Area3_No_Image_Title = UILabel()
    var Area3_Separator = UIView()
    
    var Area4_Description = UILabel()
    var Area4_Separator = UIView()
    
    var Area5_Title = UILabel()
    var Area5_1 = UILabel()
    var Area5_1_Description = UILabel()
    var Area5_1_Separator = UIView()
    var Area5_2 = UILabel()
    var Area5_2_Description = UILabel()
    var Area5_2_Separator = UIView()
    var Area5_3 = UILabel()
    var Area5_3_Description = UILabel()
    var Area5_3_Separator = UIView()
    var Area5_4 = UILabel()
    var Area5_4_Description = UILabel()
    var Area5_4_Separator = UIView()
    var Area5_5 = UILabel()
    var Area5_5_Description = UILabel()
    var Area5_5_Separator = UIView()
    var Area5_6 = UILabel()
    var Area5_6_Description = UILabel()
    var Area5_6_Separator = UIView()
    var Area5_7 = UILabel()
    var Area5_7_Description = UILabel()
    var Area5_7_Separator = UIView()
    
    var Area5_8_Developer_Website = UIButton()
    var Area5_8_Icon = UIImageView()
    var Area5_8_Separator = UIView()
    var Area5_9_Dollor = UIButton()
    var Area5_9_Icon = UIImageView()
    var Area5_9_Separator = UIView()
    
    var Area6_Title = UILabel()
    var Area6_1_Repo_Icon = UIImageView()
    var Area6_1_Repo_Name = UILabel()
    var Area6_2_Repo_Link = UILabel()
    
    var Area7_License_Title = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("[*] Catch package info:")
        print(self.this_package?.info as Any)
        
        self.container.addSubviews([Area1_Package_Icon,
                               Area1_Package_Name,
                               Area1_Package_ID,
                               Area1_Add_Queue_Button,
                               Area1_Share_Button,
                               Area1_Separator,
                               Area2_Whats_New,
                               Area2_Version,
                               Area2_Description,
                               Area2_Separator,
                               Area3_Preview,
                               Area3_Images,
                               Area3_No_Image_Title,
                               Area3_Separator,
                               Area4_Description,
                               Area4_Separator,
                               Area5_Title,
                               Area5_1,
                               Area5_1_Description,
                               Area5_1_Separator,
                               Area5_2,
                               Area5_2_Description,
                               Area5_2_Separator,
                               Area5_3,
                               Area5_3_Description,
                               Area5_3_Separator,
                               Area5_4,
                               Area5_4_Description,
                               Area5_4_Separator,
                               Area5_5,
                               Area5_5_Description,
                               Area5_5_Separator,
                               Area5_6,
                               Area5_6_Description,
                               Area5_6_Separator,
                               Area5_7,
                               Area5_7_Description,
                               Area5_7_Separator,
                               Area5_8_Developer_Website,
                               Area5_8_Icon,
                               Area5_8_Separator,
                               Area5_9_Dollor,
                               Area5_9_Icon,
                               Area5_9_Separator,
                               Area6_Title,
                               Area6_1_Repo_Icon,
                               Area6_1_Repo_Name,
                               Area6_2_Repo_Link,
                               Area7_License_Title])
        
        
        
    }
    


}




extension Saily_UI_Tweak_Native: UICollectionViewDelegateFlowLayout {
    
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
