//
//  na.swift
//  Bazar
//
//  Created by iOSayed on 13/06/2023.
//

import Foundation
import UIKit

class RoundedNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius: CGFloat = 25

        // Create a path for the rounded corners
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

        // Create a shape layer with the rounded path
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath

        // Set the layer mask of the navigation bar
        layer.mask = maskLayer
    }
}
