//
//  ProdSpecialCell.swift
//  Bazar
//
//  Created by khaled on 21/05/2022.
//  Copyright © 2022 roll. All rights reserved.
//

import UIKit

class MsgMapRecieverCell: MsgGlobalCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lbl_loc_main: UILabel!
    @IBOutlet weak var lbl_loc_sub: UILabel!
    @IBOutlet weak var img_map: UIImageView!
    @IBOutlet weak var lbl_date: UILabel!
    
    override func awakeFromNib() {
        img_map.clipsToBounds = true
        img_map.layer.cornerRadius = 8
        img_map.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    override func configure(data:Result) {
//        if data.rid == AppDelegate.currentUser.id {
//            viewContainer.backgroundColor = .gray
//        }else {
//            viewContainer.backgroundColor =  UIColor(named: "#0093F5")
//        }
        if let locData = data.msg?.components(separatedBy: "%%"){
            lbl_loc_main.text = locData[2].formatAddress["main"]
            lbl_loc_sub.text = locData[2].formatAddress["sub"]
            lbl_loc_main.setLineSpacing(lineHeightMultiple:1.2)
            lbl_loc_sub.setLineSpacing(lineHeightMultiple:1.2)
            if let image = data.image {
                img_map.setImageWithLoading(url: image)
            }
            
          
        }
        
    }
}
