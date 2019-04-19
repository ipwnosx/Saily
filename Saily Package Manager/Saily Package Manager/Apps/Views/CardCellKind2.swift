//
//  CardCellKind1.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import UIKit

class CardCellKind2: UICollectionViewCell {

    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var BigTitle: UILabel!
    @IBOutlet weak var SamllTitle: UILabel!
    @IBOutlet weak var DetailText: UITextView!
    
    func apart_init(img: UIImage, title: String, sub_title: String, detail: String) {
        self.BGImage.image = img
        self.BigTitle.text = title
        self.SamllTitle.text = sub_title
        self.DetailText.text = detail
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


class CardViewKind2: UIView {
    
    @IBOutlet weak var BGImage: UIImageView!
    @IBOutlet weak var BigTitle: UILabel!
    @IBOutlet weak var SamllTitle: UILabel!
    @IBOutlet weak var DetailText: UITextView!
    
    func apart_init(img: UIImage, title: String, sub_title: String, detail: String) {
        self.BGImage.image = img
        self.BigTitle.text = title
        self.SamllTitle.text = sub_title
        self.DetailText.text = detail
    }
    
}
