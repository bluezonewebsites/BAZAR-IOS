//
//  TabbarViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 1/08/2023.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
            super.viewDidLoad()
            delegate = self
        }
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            if let navigationController = viewController as? UINavigationController,
                navigationController.viewControllers.contains(where: { $0 is SearchBaseViewController }) {
                //show pop up view
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:"emptySearchText"), object: nil)
                navigationController.popToRootViewController(animated: false)
                return true
            } else  {
                return true
            }
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
