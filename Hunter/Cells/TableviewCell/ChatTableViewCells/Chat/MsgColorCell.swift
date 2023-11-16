//
//  ProdSpecialCell.swift
//  Bazar
//
//  Created by khaled on 21/05/2022.
//  Copyright © 2022 roll. All rights reserved.
//

import UIKit

class MsgColorCell: MsgGlobalCell {

    @IBOutlet weak var lbl_color_code: UILabel!
    @IBOutlet weak var colorv: UIView!
    
    override func configure(data:Result) {
        lbl_color_code.text = data.msg?.uppercased()
        colorv.backgroundColor = UIColor.init(hexString: data.msg ?? "#55555")
    }
}
