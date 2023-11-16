//
//  Localization.swift
//  fa3lity
//
//  Created by Amal Elgalant on 19/11/2020.
//  Copyright © 2020 Amal Elgalant. All rights reserved.
//


import UIKit

extension String {
    public var localize: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIButton {
    @IBInspectable public var Localize: Bool {
        get { return true }
        set { if (newValue) {
            setTitle( title(for:.normal)?.localize,      for:.normal)
            setTitle( title(for:.highlighted)?.localize, for:.highlighted)
            setTitle( title(for:.selected)?.localize,    for:.selected)
            setTitle( title(for:.disabled)?.localize,    for:.disabled)
        }}
    }
}

extension UILabel {
    @IBInspectable public var Localize: Bool {
        get { return true }
        set { if (newValue) { text = text?.localize }}
    }
}

extension UITabBarItem {
    @IBInspectable public var Localize: Bool {
        get { return true }
        set { if (newValue) { title = title?.localize }}
    }
}

extension UITextField {
    @IBInspectable public var Localize: Bool {
        get { return true }
        set { if (newValue) {
            placeholder = placeholder?.localize
            text = text?.localize
        }}
    }
}
extension UISearchBar {
    @IBInspectable public var Localize: Bool {
        get { return true }
        set { if (newValue) {
            placeholder = placeholder?.localize
            text = text?.localize
        }}
    }
}
