//
//  ffff.swift
//  Bazar
//
//  Created by iOSayed on 21/05/2023.
//

import UIKit
import MOLH

class LocalizedImage: UIImageView {
    override func awakeFromNib() {
        flipedDirection()
    }
    
    func flipedDirection() {
        if MOLHLanguage.currentAppleLanguage() != "ar" {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
}
