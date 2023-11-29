//
//  FanMenuView.swift
//  NewBazar
//
//  Created by iOSayed on 28/11/2023.
//

import Foundation

import UIKit
import MOLH

protocol FanMenuDelegate:AnyObject {
    func didTapButton1()
}

class FanMenuView: UIView {
    let buttonSize: CGFloat = 60
    let fanRadius: CGFloat = 100
    var isMenuOpen = false
    weak var delegate:FanMenuDelegate?
    
    // Define buttons
    private let mainButton = UIButton()
    private let button1 = UIButton()
    private let button2 = UIButton()
    private let button3 = UIButton()

    // Closure properties for button actions
    var button1Action: (() -> Void)?
    var button2Action: (() -> Void)?
    var button3Action: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Setup Main Button
        mainButton.frame = CGRect(x: bounds.midX - buttonSize / 2, y: bounds.midY - buttonSize / 2, width: buttonSize, height: buttonSize)
        mainButton.layer.cornerRadius = buttonSize / 2
        mainButton.setImage(isMenuOpen ? UIImage(named: "close_icon") : UIImage(named: "phone_icon"), for: .normal)
        
        mainButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        addSubview(mainButton)

        
        // Setup Fan Buttons
        setupButton(button: button1, color: .clear, image: UIImage(named: "phone_icon")!, action: #selector(button1Tapped))
        setupButton(button: button2, color: .clear, image: UIImage(named: "phone_icon")!, action: #selector(button2Tapped))
        setupButton(button: button3, color: .clear, image: UIImage(named: "phone_icon")!, action: #selector(button3Tapped))
//        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)

    }

    private func setupButton(button: UIButton, color: UIColor,image:UIImage, action: Selector) {
        button.frame = CGRect(x: bounds.midX - buttonSize / 2, y: bounds.midY - buttonSize / 2, width: buttonSize, height: buttonSize)
        button.setImage(image, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = buttonSize / 2
        button.alpha = 0
        button.isUserInteractionEnabled = true
//        button.addTarget(self, action: action, for: .touchUpInside)
        addSubview(button)
    }

    @objc private func toggleMenu() {
        isMenuOpen.toggle()
        mainButton.setImage(isMenuOpen ? UIImage(named: "close_icon") : UIImage(named: "phone_icon"), for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.button1.alpha = self.isMenuOpen ? 1 : 0
            self.button2.alpha = self.isMenuOpen ? 1 : 0
            self.button3.alpha = self.isMenuOpen ? 1 : 0

            if !MOLHLanguage.isArabic() {
                self.button1.center = self.isMenuOpen ? CGPoint(x: self.bounds.midX, y: self.bounds.midY - self.fanRadius) : self.mainButton.center
                self.button2.center = self.isMenuOpen ? CGPoint(x: self.bounds.midX + self.fanRadius / sqrt(2), y: self.bounds.midY - self.fanRadius / sqrt(2)) : self.mainButton.center
                self.button3.center = self.isMenuOpen ? CGPoint(x: self.bounds.midX + self.fanRadius, y: self.bounds.midY) : self.mainButton.center
            } else {
                self.button1.center = self.isMenuOpen ? CGPoint(x: self.bounds.midX, y: self.bounds.midY - self.fanRadius) : self.mainButton.center
                self.button2.center = self.isMenuOpen ? CGPoint(x: self.bounds.midX - self.fanRadius / sqrt(2), y: self.bounds.midY - self.fanRadius / sqrt(2)) : self.mainButton.center
                self.button3.center = self.isMenuOpen ? CGPoint(x: self.bounds.midX - self.fanRadius, y: self.bounds.midY) : self.mainButton.center
            }

//            self.mainButton.transform = CGAffineTransform(rotationAngle: self.isMenuOpen ? .pi / 4 : 0)
        }
    }

    @objc private func button1Tapped() {
        delegate?.didTapButton1()
        button1Action?()
    }

    @objc private func button2Tapped() {
        button2Action?()
    }

    @objc private func button3Tapped() {
        button3Action?()
    }
}
