//
//  notCell.swift
//  kashcoul
//
//  Created by khaled mohammed on 2/11/17.
//  Copyright © 2017 khaled mohammed. All rights reserved.
//

import UIKit
import M13Checkbox

class roomCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var last_msg: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var since: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var chk_width: NSLayoutConstraint!
    @IBOutlet weak var chk: M13Checkbox!

    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
        
        chk.markType = .checkmark
        chk.boxType = .square
        chk.boxLineWidth = 1.5
        chk.checkmarkLineWidth = 1.5
        chk.secondaryTintColor = UIColor(named: "#0093F5")
        chk.secondaryCheckmarkTintColor = UIColor.white
        chk.tintColor = UIColor(named: "#0093F5")
        chk.stateChangeAnimation = .bounce(.fill)
    }
}

