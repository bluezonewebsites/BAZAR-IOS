//
//  CategoryNavigationController.swift
//  Bazar
//
//  Created by Amal Elgalant on 12/09/2023.
//

import UIKit
import WoofTabBarController

class CategoryNavigationController: UINavigationController {
    static func instantiate()->CategoryNavigationController{
        let controller = UIStoryboard(name: CATEGORRY_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"categoryT") as! CategoryNavigationController
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
extension CategoryNavigationController:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {

    func woofTabBarItem() -> WoofTabBarItem {
        return WoofTabBarItem(title: "Categories".localize, image: "CategoryIcon 1", selectedImage: "CategoryButtonIcon")
    }
}
