//
//  DiscoverClass.swift
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright © 2019 Lakr233. All rights reserved.
//

import Foundation
import UIKit

let preview_discover_file = "https://raw.githubusercontent.com/Co2333/SailyHomePagePreview/master/preview"

// subtitle, title, image, detail, link
class discover_C {
    
    public var title_big        = String()
    public var title_small      = String()
    public var text_details     = String()
    public var image_link       = String()
    public var web_link         = String()
    public var tweak_id         = String()
    public var tweak_repo       = String()
    public var card_kind        = 0
    
    public var content_view     = UIView()
    
    init() {
        self.card_kind = 1
    }
    
    func reg_content_view(_ view: UIView) {
        self.content_view = view
    }
    
    func apart_init(withString: String) {
        
        // |中文——————————————————————————————————|<———————————>|英文——————————————————————————————|
        // |标题|原网页链接|卡片标题|卡片副标题|卡片描述|卡片背景|卡片类型|卡片标题|卡片副标题|卡片描述|英文网页链接|是否有插件推荐|插件id|插件默认源地址|
        //   0    1         2       3       4        5      6       7      8       9       10      11         12         13
        
        let splited = withString.split(separator: "|")
        
        if (splited.count < 14) {
            self.title_big = "ERROR"
            self.title_small = "文档格式不正确"
            self.text_details = "Please contact developer for a fix or more. mailto://saily@233owo.com"
            self.image_link = "https://www.virginexperiencedays.co.uk/content/img/product/large/the-view-from-the-12102928.jpg"
            return
        }
        
        if (Saily.is_Chinese) {
            self.web_link = splited[1].description
            self.title_big = splited[2].description
            self.title_small = splited[3].description
            self.text_details = splited[4].description
        }else{
            self.title_big = splited[7].description
            self.title_small = splited[8].description
            self.text_details = splited[9].description
            self.web_link = splited[10].description
        }
        
        if (splited[11] == "true") {
            self.tweak_id = splited[12].description
            self.tweak_id = splited[13].description
        }
        
        self.image_link = splited[5].description
        self.card_kind = Int(splited[6]) ?? 1
        
    }
    
    
}


