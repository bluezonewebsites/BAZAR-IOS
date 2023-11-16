//
//  AddAddNavigationController.swift
//  Bazar
//
//  Created by Amal Elgalant on 12/09/2023.
//

import UIKit
import WoofTabBarController

class AddAddNavigationController: UINavigationController {
    static func instantiate()->AddAddNavigationController{
        let controller = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"adT") as! AddAddNavigationController
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
extension AddAddNavigationController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {

    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Add Your Ad".localize, image: "addAdvsButtonIconGray", selectedImage: "AddAdsIconMain")
    }
}
