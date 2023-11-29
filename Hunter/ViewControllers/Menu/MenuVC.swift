//
//  SettingVC.swift
//  Bazar
//
//  Created by iOSayed on 20/05/2023.
//

import UIKit
import MOLH
import WoofTabBarController

class MenuVC: UIViewController {

    static func instantiate()->MenuVC{
        let controller = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:MENU_VCID) as! MenuVC
        return controller
    }
    
    //MARK: IBOutlet
    
    @IBOutlet weak var userImageContainerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var loginViewContainer: UIView!
    @IBOutlet weak var logoutView: UIView!
  
    @IBOutlet weak var englishButton: UIButton!
    
    @IBOutlet weak var arabicButton: UIButton!
    
    var woofTabBarView: WoofTabBarView?
    var woofTabBarController: WoofTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ConfigureUI()
        userImageContainerView.layer.cornerRadius = userImageContainerView.frame.height / 2
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goHome(_:)), name: NSNotification.Name(rawValue: "goHome"), object: nil)

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        ConfigureUI()
        if MOLHLanguage.currentAppleLanguage() == "en"{
            englishButtonPressed()
        }else{
            arabicButtonPressed()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func goHome(_ notification: NSNotification) {
        tabBarController?.selectedIndex = 0
        
    }
    
    //MARK: Private Methods
    
    private func ConfigureUI(){
        
//        navigationController?.navigationBar.isHidden = true
//        tabBarController?.tabBar.isHidden = false
//        dateLabel.text = FormattedDate()
        
//        loginButton.shake()
        if StaticFunctions.isLogin() {
            //logged in
            userNameLabel.text = AppDelegate.currentUser.name ?? ""
            if AppDelegate.currentUser.isStore ?? false {
                if let logo =  AppDelegate.currentUser.store?.logo {
                    userImageView.setImageWithLoading(url:logo,placeholder: "logo_photo")
                }else{
                    userImageView.setImageWithLoading(url: AppDelegate.currentUser.pic ?? "",placeholder: "logo_photo")
                }
                
            }else{
                userImageView.setImageWithLoading(url: AppDelegate.currentUser.pic ?? "",placeholder: "logo_photo")
            }
            if AppDelegate.currentUser.isStore ?? false {
                loginButton.isHidden = false
                loginViewContainer.isHidden = false
            }else{
                loginViewContainer.isHidden = true
                loginButton.isHidden = true
                
            }
            
            logoutView.isHidden = false
            loginButton.setTitle("Stores Packages".localize, for: .normal)
        }else {
           // logged out
            loginButton.shake()
            userNameLabel.text = "Guest".localize
            loginButton.setTitle("Login/Register".localize, for: .normal)
            logoutView.isHidden = true
            loginButton.isHidden = false
            loginViewContainer.isHidden = false
            
        }
    }
    
    
    
   
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
      //  basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
        if loginButton.titleLabel?.text == "Stores Packages".localize {
            let packagesVC = PackagesVC.instantiate()
            navigationController?.pushViewController(packagesVC, animated: true)
        }else{
            basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
        }
        
    }
    
    @IBAction func didTapProfileButton(_ sender: UIButton) {
        print("didTapProfileButton")
//        if StaticFunctions.isLogin() {
//            let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PROFILE_VCID) as! ProfileVC
//            vc.modalPresentationStyle = .fullScreen
//           // present(vc, animated: true)
////            presentDetail(vc)
//            navigationController?.pushViewController(vc, animated: true)
//        }else {
//            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Go To Profile!".localize)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
//                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
//            }
//
//        }
        if StaticFunctions.isLogin() {
            print(AppDelegate.currentUser.isStore)
            DispatchQueue.main.async {
                if AppDelegate.currentUser.isStore ?? false {
                    let storeProfileVC = StoreProfileVC.instantiate()
//                    let nav = UINavigationController(rootViewController: storeProfileVC)
                    storeProfileVC.otherUserId = AppDelegate.currentUser.id ?? 0
                    self.navigationController?.pushViewController(storeProfileVC, animated: true)
                }else{
                    let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: PROFILE_VCID) as! ProfileVC
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else {
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Go To Profile!".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
        }

    }
    
    @IBAction func didTapAddAdButton(_ sender: Any) {

        if StaticFunctions.isLogin() {
            let vc = UIStoryboard(name: ADVS_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: ADDADVS_VCID) as! AddAdvsVC
            vc.modalPresentationStyle = .fullScreen
            vc.isFromHome = false
            vc.isComeFromProfile = true
            navigationController?.pushViewController(vc, animated: true)
            

        }else {
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Add Post!".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
        }
        
    }
    
    
    @IBAction func didTapFavoutitesButton(_ sender: UIButton) {
        
        if StaticFunctions.isLogin() {
            let vc = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }else {
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Go To Favoutites!".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
            
        }
    }
    
    @IBAction func didTapMyAdsButton(_ sender: UIButton)  {
        if StaticFunctions.isLogin() {
            if let vc = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: MYADS_VCID) as? MyAdsVC {
                vc.modalPresentationStyle = .fullScreen
                vc.userId = AppDelegate.currentUser.id ?? 0
//                presentDetail(vc)
                vc.navigationController?.navigationBar.isHidden = false
                navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Go To Ads !".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
        }
    }
    
    
    @IBAction func didTapMyAsksButton(_ sender: UIButton) {
        
        if StaticFunctions.isLogin() {
            
            let vc = UserBlockedVC.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        }else {
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Go To Blocked Users!".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
        }

        
    }
    @IBAction func didTapChangeCountryButton(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "ChangeCountryVC") as! ChangeCountryVC
        vc.modalPresentationStyle = .fullScreen
//        presentDetail(vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapSettingsButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        vc.modalPresentationStyle = .fullScreen
//        presentDetail(vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapVerifyAccountButton(_ sender: UIButton) {
        
        if StaticFunctions.isLogin() {
            let vc = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: "VerifyAccountVC") as! VerifyAccountVC
            vc.modalPresentationStyle = .fullScreen
//            presentDetail(vc)
            navigationController?.pushViewController(vc, animated: true)
            
            
        }else {
            StaticFunctions.createErrorAlert(msg: "Please Login First To Can Go To Verify Account!".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
        }

    }
    
    //Change Language
    
    
    @IBAction func didTapEnglishButton(_ sender: UIButton) {
        if MOLHLanguage.currentAppleLanguage() != "en" {
            MOLH.setLanguageTo("en")
            englishButtonPressed()
            if #available(iOS 13.0, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.swichRoot()
                }
            } else {
                // Fallback on earlier versions
                MOLH.reset()
            }
        }
    }
    
    @IBAction func didTapArabicButton(_ sender: UIButton) {
        if MOLHLanguage.currentAppleLanguage() != "ar" {
            MOLH.setLanguageTo("ar")
            arabicButtonPressed()
            if #available(iOS 13.0, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.swichRoot()
                }
                
            } else {
                // Fallback on earlier versions
                MOLH.reset()
            }
        }
    }
    
    @IBAction func didTapLogoutButton(_ sender: UIButton) {
        displayImageActionSheet()
      //  logout()
    }
    
    
    fileprivate func arabicButtonPressed(){
        arabicButton.backgroundColor = UIColor(named: "#0093F5")
        englishButton.backgroundColor = UIColor.white
        arabicButton.setTitleColor(UIColor.white, for: .normal)
        englishButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    fileprivate func englishButtonPressed(){
        englishButton.backgroundColor = UIColor(named: "#0093F5")
        englishButton.setTitleColor(UIColor.white, for: .normal)
        arabicButton.setTitleColor(UIColor.black, for: .normal)
        arabicButton.backgroundColor = UIColor.white
    }
    
    
}
extension MenuVC {
    
    private func displayImageActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectAction = UIAlertAction(title: "Log out".localize, style: .default) { (_) in
                    self.logout()
                }
        // Customize the color of the actions
        selectAction.setValue(UIColor.red, forKey: "titleTextColor")
                alertController.addAction(selectAction)
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                let imageView = UIImageView(image: UIImage(named: "log-out"))
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                let imageWidth: CGFloat = 20
                let imageHeight: CGFloat = 20
                let padding: CGFloat = 16.0
                let customView = UIView(frame: CGRect(x: padding, y: padding, width: imageWidth, height: imageHeight))
                imageView.frame = customView.bounds
                customView.addSubview(imageView)
                alertController.view.addSubview(customView)
                alertController.view.bounds.size.height += (imageHeight + padding * 2)
                present(alertController, animated: true, completion: nil)
       }
    
    func logout(){
       
        AppDelegate.currentUser.id = nil
        AppDelegate.currentUser.toke = nil
        AppDelegate.currentUser.pic = "-"
        AppDelegate.currentUser.name = "Guest".localize
        AppDelegate.defaults.string(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.synchronize()
        
        self.basicPresentation(storyName: MAIN_STORYBOARD, segueId: "TabBarVC")
      
    }
}
//extension MenuVC:WoofTabBarControllerDataSource, WoofTabBarControllerDelegate {
//    
//    func woofTabBarItem() -> WoofTabBarItem {
//        return WoofTabBarItem(title: "Profile".localize, image: "userProfile", selectedImage: "ProfileButtonIcon")
//    }
//}
