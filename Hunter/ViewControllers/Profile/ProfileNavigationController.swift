//
//  ProfileNavigationController.swift
//  Bazar
//
//  Created by Amal Elgalant on 12/09/2023.
//

import UIKit
import WoofTabBarController

class ProfileNavigationController: UINavigationController {
    static func instantiate()->ProfileNavigationController{
        let controller = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"menuT") as! ProfileNavigationController
        return controller
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProfileNavigationController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {

    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Profile".localize, image: "userProfile", selectedImage: "ProfileButtonIcon")
    }
}
