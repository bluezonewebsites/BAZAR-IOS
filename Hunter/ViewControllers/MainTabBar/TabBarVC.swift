//
//  TabBarVCViewController.swift
//  Bazar
//
//  Created by iOSayed on 11/09/2023.
//

import UIKit
import WoofTabBarController

class TabBarVC: WoofTabBarController {

    static let shared = TabBarVC()
    override var defaultIndex: Int { 0 }
    
    let homeVC = HomeNavigationController.instantiate()
    let storesVC = StoreNavigationController.instantiate()
    let addAdsVC = AddAddNavigationController.instantiate()
    let categoryVC = CategoryNavigationController.instantiate()
    let menuVC = ProfileNavigationController.instantiate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
        self.configureTabBarView { (barview) in
            barview.shadow = (3.0, 0.5, .zero, .gray)
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar(_:)), name: NSNotification.Name("hideTabBar"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(showTabBar(_:)), name: NSNotification.Name("ShowTabBar"), object: nil)
       
        
    }
    
//    @objc func hideTabBar(_ notification: Notification){
//        self.configureTabBarView { (barview) in
//            barview.isHidden = true
//            self.view.backgroundColor = .white
//        }
//        }
//    @objc func showTabBar(_ notification: Notification){
//        self.configureTabBarView { (barview) in
//            barview.isHidden = false
//            self.view.backgroundColor = UIColor(named: "#0093F5")
//        }
//        }

    override func viewControllers() -> [WoofTabControllerItem] {
        return [homeVC,categoryVC,addAdsVC,storesVC,menuVC]
                //, storesVC, addAdsVC, categoryVC, menuVC]
    }
    
}

extension TabBarVC: WoofTabBarControllerBarViewDelegate {
    func shouldSelectItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) -> Bool {
        return true
    }
    
    func shouldHighlightItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) -> Bool {
        true
    }
    
    func shouldAnimateItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) -> Bool {
        true
    }
    
    func didSelectItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) {
        print("Selected \(atIndex)")
    }
    
    func didDeSelectItem(itemView: WoofTabBarItemView, vc: WoofTabBarController.WoofTabControllerItem, atIndex: Int) {
        print("De-Selected \(atIndex)")
    }
    
    func didAnimateItem(itemView: WoofTabBarItemView, destinationVC: WoofTabBarController.WoofTabControllerItem, atIndex: Int) {
        print("Ainmated \(atIndex)")
    }
}
