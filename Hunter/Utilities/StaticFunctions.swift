//
//  StaticFunctions.swift
//  Sla
//
//  Created by Amal Elgalant on 3/29/20.
//  Copyright © 2020 Amal Elgalant. All rights reserved.
//

import Foundation
import UIKit
import PhoneNumberKit
import NotificationBannerSwift
import CoreLocation
import MOLH
//import TTGSnackbar

class StaticFunctions {
    
    static func enableBtnWithoutAlpha(btn: UIButton, status check: Bool){
        if check{
            btn.isEnabled = true
        }
        else {
            btn.isEnabled = false
        }
        
    }
    
    
    static func setNavifationIcon(VC: UIViewController){
        let imageView = UIImageView(image:#imageLiteral(resourceName: "Logo White"))
        imageView.contentMode = .scaleAspectFit
        VC.navigationItem.titleView = imageView
    }
    
    static func getCurrentDevice()-> String{
        // 1. request an UITraitCollection instance
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            return "iPad"
        case .phone:
            return "iPhone"
        default:
            return "Unspecified"
        }
    }
    
    
    static func createErrorAlert(msg: String){

        let banner = NotificationBanner(title: msg, subtitle: "", style: .danger)
        ///banner.backgroundColor = UIColor(rgb: Constant.greenColor)
        banner.show(bannerPosition: .top)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            banner.dismiss()
        }
        
//        let snackbar = TTGSnackbar(message: msg, duration: .middle)
//
//
//            snackbar.backgroundColor = UIColor.init(hexString: "#f44245")
//
//        snackbar.animationType = .slideFromBottomBackToBottom
//        snackbar.messageTextAlign = MOLHLanguage.currentAppleLanguage() == "en" ? .left : .right
//        snackbar.messageTextFont = UIFont(name: "Almarai-Regular", size: 14)!
//        snackbar.show()
        
    }
    static func createSuccessAlert(msg: String){
       
        let banner = NotificationBanner(title: msg, subtitle: "", style: .success)
        ///banner.backgroundColor = UIColor(rgb: Constant.greenColor)
        banner.show(bannerPosition: .top)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            banner.dismiss()
        }
//        let snackbar = TTGSnackbar(message: msg, duration: .middle)
//
//
//            snackbar.backgroundColor = UIColor.init(hexString: "#0093F5")
//
//        snackbar.animationType = .slideFromBottomBackToBottom
//        snackbar.messageTextAlign = MOLHLanguage.currentAppleLanguage() == "en" ? .left : .right
      
//        snackbar.show()
    }
    
    static func createInfoAlert(msg: String){
       
        let banner = NotificationBanner(title: msg, subtitle: "", style: .info)
        ///banner.backgroundColor = UIColor(rgb: Constant.greenColor)
        banner.show(bannerPosition: .top)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            banner.dismiss()
        }
//        let snackbar = TTGSnackbar(message: msg, duration: .middle)
//
//
//            snackbar.backgroundColor = UIColor.init(hexString: "#0093F5")
//
//        snackbar.animationType = .slideFromBottomBackToBottom
//        snackbar.messageTextAlign = MOLHLanguage.currentAppleLanguage() == "en" ? .left : .right
      
//        snackbar.show()
    }
    static func enableBtn(btn: UIButton, status check: Bool){
        if check{
            btn.alpha = 1
            btn.isEnabled = true
        }
        else {
            btn.alpha = 0.5
            btn.isEnabled = false
        }
        
    }
    static func setHeaderLanguage(language: String){
        //        if language == "en"{
        //            Constants.HEADER["Language"] = "1"
        //        }else {
        //            Constants.HEADER["Language"] = "2"
        //
        //        }
        
    }
    static func setButtonWithIcon(button: UIButton){
                if MOLHLanguage.currentAppleLanguage() == "en"{
        button.titleEdgeInsets.left = 10
        button.imageEdgeInsets.right = 10
        button.titleEdgeInsets.right = 0
        button.imageEdgeInsets.left = 0
                }else {
                    button.titleEdgeInsets.right = 10
                    button.imageEdgeInsets.left = 10
                    button.titleEdgeInsets.left = 0
                    button.imageEdgeInsets.right = 0
                }
    }
    
    static func seteErrorLblStatus(errorLbl:UILabel, status: Bool, msg: String  ){
        errorLbl.sizeToFit()
        errorLbl.text = msg
        errorLbl.isHidden = status
        
    }
    static func checkValidPhonNumber(Phone:String  )->Bool{
        do {
            var phone = Phone
            if !Phone.starts(with: "+"){
                phone = "+" + Phone
            }
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumber = try phoneNumberKit.parse(phone)
            
            return true
            
        }
        catch {
            return false
            
        }
    }
    static func call(phone:String, vc: UIViewController){
        if phone.isEmpty{
            StaticFunctions.createErrorAlert(msg: "No phone number".localize)
            return
        }
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.open(number)
    }
    static func register(viewController: UIViewController){
        //        viewController.basicNavigation(storyName: Auth_STORY_BOARD, segueId: REGISTER_VCID)
    }
    static func isLogin() -> Bool{
        print(AppDelegate.currentUser.toke)
        if AppDelegate.currentUser.toke != nil  {
            if AppDelegate.currentUser.toke == ""{
                return false
            }
            return true
        }
        return false
    }
    
    static func backTwo(viewController: UIViewController) {
        let viewControllers: [UIViewController] = viewController.navigationController!.viewControllers as [UIViewController]
        viewController.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    static func backThree(viewController: UIViewController) {
        let viewControllers: [UIViewController] = viewController.navigationController!.viewControllers as [UIViewController]
        viewController.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
    }
    static func backNumber(viewController: UIViewController, number: Int = 2) {
        let viewControllers: [UIViewController] = viewController.navigationController!.viewControllers as [UIViewController]
        viewController.navigationController!.popToViewController(viewControllers[viewControllers.count - (number + 1)], animated: true)
    }
    
    
    static func setHeaderToken(){
        //        Constants.HEADER["Authorization"] = "Bearer \(AppDelegate.currentUser.token ?? "" )"
    }
    static func NoIntertAlert( _ viewcontroller: UIViewController){
        StaticFunctions.createErrorAlert(msg: NO_INTERNET_CONNECTION)
    }
    static func addParam ( link: inout String , para:[String:Any], isFirst: Bool = true){
        var isfirst = isFirst
        for (key, value) in para {
            
            
            if isfirst  {
                isfirst = false
                link +=  "?\(key)=\(value)"
            }
            else {
                link +=  "&\(key)=\(value)"
                
            }
        }
    }
    static func getAddress(lat: Double, long: Double, handler: @escaping (String) -> Void)
    {
        var address: String = ""
        let geoCoder = CLGeocoder()
        var location = CLLocation(latitude: lat, longitude: long)
        
        
        //selectedLat and selectedLon are double values set by the app in a previous process
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "")
            
            // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                address += locationName + ", "
            }
            
            // Street address
            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
                address += street + ", "
            }
            
            // City
            if let city = placeMark?.addressDictionary?["City"] as? String {
                address += city + ", "
            }
            
            // Zip code
            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
                address += zip + ", "
            }
            
            // Country
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                address += country
            }
            
            // Passing address back
            handler(address)
        })
        
    }
    
   static func setImageFromAssets(_ img:UIImageView, _ src:String){
        if(src == ""){
            img.image = nil
        }else{
            img.image = UIImage(named:src)
        }
    }
    
    static func setTextColor(_ v:UIView,_ color:UIColor){
        if let v = v as? UILabel {
            v.textColor = color
        }else if let v = v as? UIButton {
            v.setTitleColor(color, for: .normal)
        }
    }
        
   
}
