//
//  SceneDelegate.swift
//  Bazar
//
//  Created by Amal Elgalant on 12/04/2023.
//

import UIKit
import FirebaseDynamicLinks


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        if let url = connectionOptions.urlContexts.first?.url {
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true)else{return}
            // pathComponents = ["", "profile", "123"]
            
            //            let pathComponents = components.path.components(separatedBy: "/")
            let pathComponents = extractCustomComponents(from: url)
            print(components, "   " , pathComponents)
            
            
            // Handle different paths
            if pathComponents.count >= 2 && pathComponents[0] == "profile" {
                let profileId = pathComponents[1]
                redirectToProfile(withId: profileId,to: "")
            }
        }
        
        if let userActivity = connectionOptions.userActivities.first {
            debugPrint("userActivity: \(userActivity.webpageURL)")
            fatalError()
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // Example: URL - bazaar://profile/123
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true)else{return}
            // pathComponents = ["", "profile", "123"]
            
            //            let pathComponents = components.path.components(separatedBy: "/")
            let pathComponents = extractCustomComponents(from: url)
            print(components, "   " , pathComponents)
            
            
            // Handle different paths
            if pathComponents.count >= 2 && pathComponents[0] == "profile" {
                let profileId = pathComponents[1]
                redirectToProfile(withId: profileId,to: "")
            }
        }
        
        
    }
    
    
    
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else { return }
                if let dynamicLink = dynamicLink, let url = dynamicLink.url {
                    self.handleDynamicLink(url)
                }
            }

            if linkHandled {
                return
            }
            // Additional URL handling if necessary
        }
    }

    func handleDynamicLink(_ url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           let queryItems = components.queryItems {
            let path = components.path

            switch path {
            case "/profile/":
                if let profileId = queryItems.first(where: { $0.name == "profile_id" })?.value {
                    // Handle profile link with profileId
                    print(profileId)
                    redirectToProfile(withId: profileId, to: path)
                }
            case "/prod/":
                if let adId = queryItems.first(where: { $0.name == "ad_id" })?.value {
                    // Handle product link with adId
                    print(adId)
                    redirectToProfile(withId: adId, to: path)

                }
            case "/stores/":
                if let profileId = queryItems.first(where: { $0.name == "profile_id" })?.value {
                    // Handle store link with profileId
                    print(profileId)
                    redirectToProfile(withId: profileId, to: path)

                }
            default:
                break
            }
        }
    }


    
    
    func extractCustomComponents(from url: URL) -> [String] {
        let urlString = url.absoluteString
        
        guard let range = urlString.range(of: "://") else {
            return []
        }
        
        let parametersString = urlString[range.upperBound...]
        let components = parametersString.components(separatedBy: "/")
        
        return components.filter { !$0.isEmpty }
    }
    
    
    func handleIncomingURL(_ url: URL) {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let path = components.path else {
            return
        }
        
        let pathComponents = path.components(separatedBy: "/")
        
        // Example: URL - bazaar://profile/123
        if pathComponents.count > 2 && pathComponents[1] == "profile" {
            let profileId = pathComponents[2]
            redirectToProfile(withId: profileId,to:"")
        }
    }
    
    func redirectToProfile(withId id: String, to screen: String) {
        
        guard let rootViewController = getRootViewController() else {
            return
        }

        switch screen {
        case "/profile/":
            if AppDelegate.currentUser.id.safeValue == Int(id) {
                let profileVC = ProfileVC.instantiate()
                profileVC.user.id = Int(id) ?? 0
                navigateToViewController(profileVC, using: rootViewController)
            }else{
                let otherUserProfile = OtherUserProfileVC.instantiate()
                otherUserProfile.OtherUserId = Int(id) ?? 0
                navigateToViewController(otherUserProfile, using: rootViewController)
            }
         
            
        case "/prod/":
            let productVC = ProductViewController.instantiate()
            productVC.product.id = Int(id) ?? 0
            navigateToViewController(productVC, using: rootViewController)
            
        case "/stores/":
            let storeProfileVC = StoreProfileVC.instantiate()
            storeProfileVC.otherUserId = Int(id) ?? 0
            navigateToViewController(storeProfileVC, using: rootViewController)
            
        default:
            break
        }
    }
    
    private func navigateToViewController(_ viewController: UIViewController, using rootViewController: UIViewController) {
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else if let tabBarController = rootViewController as? UITabBarController,
                  let navigationController = tabBarController.selectedViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            // Adjust this part as per your app's view hierarchy
            rootViewController.present(viewController, animated: true)
        }
    }
    
    func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            return nil
        }
        return rootViewController
    }
}


