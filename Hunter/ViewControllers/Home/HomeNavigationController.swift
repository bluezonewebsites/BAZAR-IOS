//
//  HomeNavigationController.swift
//  Bazar
//
//  Created by Amal Elgalant on 12/09/2023.
//

import UIKit
import WoofTabBarController

class HomeNavigationController: UINavigationController {
    
    
    static func instantiate()->HomeNavigationController{
        let controller = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"homeT") as! HomeNavigationController
        return controller
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    
   

}

extension HomeNavigationController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {
    
    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Home".localize, image: "home", selectedImage: "HomeButtonIcon",notificationCount: Constants.notificationsCount)
    }
}
