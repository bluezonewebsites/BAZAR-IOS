//
//  StoreNavigationController.swift
//  Bazar
//
//  Created by Amal Elgalant on 12/09/2023.
//

import UIKit
import WoofTabBarController

class StoreNavigationController: UINavigationController {
    static func instantiate()->StoreNavigationController{
        let controller = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier:"storeT" ) as! StoreNavigationController
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
extension StoreNavigationController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {

    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Commercial".localize, image: "storeIconGray", selectedImage: "storeButtonIcon")
    }
}
