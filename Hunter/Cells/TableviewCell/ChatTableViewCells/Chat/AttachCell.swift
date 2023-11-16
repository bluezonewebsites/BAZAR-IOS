//
//  ProdSpecialCell.swift
//  Bazar
//
//  Created by khaled on 21/05/2022.
//  Copyright © 2022 roll. All rights reserved.
//

import UIKit

class AttachCell: UICollectionViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    func configure(data:Attachment) {
        lbl_title.text = data.title
        img.localImg(src: data.pic)
    }
}
