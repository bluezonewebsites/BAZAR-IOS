//
//  FanMenuCustomView.swift
//  NewBazar
//
//  Created by iOSayed on 28/11/2023.
//

import Foundation
import UIKit

class CustomFanMenu: UIViewController {
    let buttonSize: CGFloat = 60
    let fanRadius: CGFloat = 100
    var isMenuOpen = false

    // Define buttons
    let mainButton = UIButton()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Main Button
        mainButton.frame = CGRect(x: 150, y: 300, width: buttonSize, height: buttonSize)
        mainButton.backgroundColor = .red
        mainButton.layer.cornerRadius = buttonSize / 2
        mainButton.setImage(UIImage(systemName: "plus"), for: .normal)
        mainButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        view.addSubview(mainButton)

        // Setup Fan Buttons
        setupButton(button: button1, color: .green, action: #selector(button1Action))
        setupButton(button: button2, color: .blue, action: #selector(button2Action))
        setupButton(button: button3, color: .yellow, action: #selector(button3Action))
    }

    func setupButton(button: UIButton, color: UIColor, action: Selector) {
        button.frame = CGRect(x: 150, y: 300, width: buttonSize, height: buttonSize)
        button.backgroundColor = color
        button.layer.cornerRadius = buttonSize / 2
        button.alpha = 0
        button.addTarget(self, action: action, for: .touchUpInside)
        view.addSubview(button)
    }

    @objc func toggleMenu() {
        isMenuOpen.toggle()
        let layoutDirection = UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute)
        let isRTL = layoutDirection == .rightToLeft

        UIView.animate(withDuration: 0.3) {
            self.button1.alpha = self.isMenuOpen ? 1 : 0
            self.button2.alpha = self.isMenuOpen ? 1 : 0
            self.button3.alpha = self.isMenuOpen ? 1 : 0

            if isRTL {
                self.button1.center = self.isMenuOpen ? CGPoint(x: 150, y: 200) : self.mainButton.center
                self.button2.center = self.isMenuOpen ? CGPoint(x: 193, y: 250) : self.mainButton.center
                self.button3.center = self.isMenuOpen ? CGPoint(x: 250, y: 300) : self.mainButton.center
            } else {
                self.button1.center = self.isMenuOpen ? CGPoint(x: 150, y: 200) : self.mainButton.center
                self.button2.center = self.isMenuOpen ? CGPoint(x: 107, y: 250) : self.mainButton.center
                self.button3.center = self.isMenuOpen ? CGPoint(x: 50, y: 300) : self.mainButton.center
            }

            self.mainButton.transform = CGAffineTransform(rotationAngle: self.isMenuOpen ? .pi / 4 : 0)
        }
    }

    @objc func button1Action() {
        // Implement button 1 action
        print("dsdsdsdd")
    }

    @objc func button2Action() {
        // Implement button 2 action
    }

    @objc func button3Action() {
        // Implement button 3 action
    }
}
