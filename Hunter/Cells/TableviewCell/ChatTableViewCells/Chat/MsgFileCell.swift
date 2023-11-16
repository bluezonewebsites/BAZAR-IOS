//
//  ProdSpecialCell.swift
//  Bazar
//
//  Created by khaled on 21/05/2022.
//  Copyright © 2022 roll. All rights reserved.
//

import UIKit

class MsgFileCell: MsgGlobalCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var file_name: UILabel!
    @IBOutlet weak var ext: UILabel!
    override func awakeFromNib() {
        container.apply_right_bubble()
    }
    
    override func configure(data:Result) {
//        if data.file_name == "-"{
//            file_name.text = data.msg.toUrl.lastPathComponent
//        }else{
//            file_name.text = data.file_name
//        }
    }
}
