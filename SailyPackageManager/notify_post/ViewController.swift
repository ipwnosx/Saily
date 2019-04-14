//
//  ViewController.swift
//  notify_post
//
//  Created by Lakr Aream on 2019/4/15.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

import UIKit

let object = thisObject()

class ViewController: UIViewController {

    @IBOutlet weak var textBox: UITextField!
    
    @IBAction func call(_ sender: Any) {
        let str = textBox.text ?? " "
        object.callNotify(str)
    }
    

}

