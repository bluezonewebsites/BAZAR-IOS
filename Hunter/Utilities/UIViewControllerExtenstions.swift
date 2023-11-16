//
//  UIViewControllerExtenstions.swift
//  WeasyVendor
//
//  Created by Amal Elgalant on 2/6/20.
//  Copyright © 2020 Amal Elgalant. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PhoneNumberKit
import AVFoundation
import AVKit
import MapKit
import DropDown
//import NextGrowingTextView

extension UIViewController :NVActivityIndicatorViewable{
    
    //check email validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func isTextEmpty(_ txt:UITextField) -> Bool{
        guard let text = txt.text else {return false}
        return text.isEmpty ? true : false
    }
    
    func FormattedDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d-MM-YYYY"
        formatter.locale = NSLocale(localeIdentifier: "en_USA") as Locale
        return formatter.string(from: date)
    }
    
    //Share
    func shareContent(text:String) {
        let textToShare = [ text] as Any
        let activityViewController = UIActivityViewController(activityItems: textToShare as! [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setupView(name: String, editProfile: Bool = false, noBack: Bool = false){
        backUsingSWip()
        
        
        
        
        //
        //
        
        let notification = UIBarButtonItem(image: #imageLiteral(resourceName: "Icon ionic-ios-notifications"), style: .plain, target: self, action: #selector(openNotification))
        //        if StaticFunctions.isLogin(){
        //            self.getNotifications(){counter in
        //                if counter > 0{
        //                    notification.addBadge(number: counter)
        //                }else{
        //                    notification.removeBadge()
        //                }
        //
        //            }
        //
        //
        //        }
        navigationItem.rightBarButtonItems = [notification]
        
        
        let titleBtn = UIBarButtonItem(title: name, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [titleBtn]
        if !noBack{
            let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-arrow"), style: .plain, target: self, action: #selector(back))
            navigationItem.leftBarButtonItems?.insert(backBtn, at: 0)
            
        }
        
        
        
        if editProfile{
            let editBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "Edit"), style: .plain, target: self, action: #selector(EditProfile))
            navigationItem.rightBarButtonItems?.append(editBtn)
        }
        
        
    }
    
    func makePhoneCall(phone phoneNumber: String) {
           if let url = URL(string: "tel://\(phoneNumber)") {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                   // Handle the case where the device can't make phone calls (e.g., iPad or simulator)
                   print("Phone call not available")
               }
           }
       }
    func openWhatsApp(number: String, message: String = "") {
            // Check if WhatsApp is installed
            if let whatsappURL = URL(string: "whatsapp://send?phone=\(number)&text=\(message)") {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                } else {
                    // Handle the case where WhatsApp is not installed
                    print("WhatsApp is not installed on this device.")
                }
            }
        }
    
    func openURL(_ urlString: String) {
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Handle the case where the URL cannot be opened
                    print("URL cannot be opened.")
                }
            } else {
                // Handle invalid URL
                print("Invalid URL.")
            }
        }
    //    func getNotifications(completion: @escaping(Int)->()){
    //        if Reachability.isConnectedToNetwork(){
    //            UtilitiesController.shared.getNotifications(completion: {
    //                notifications , check, msg in
    //                if check == 0 {
    //                    completion(notifications.counter)
    //                }
    //                else{
    //                    completion(-1)
    //
    //                }
    //            }, open: false)
    //        }else{
    //            completion(-1)
    //
    //        }
    //    }
    @objc func openNotification(){
        //        basicNavigation(storyName: MAIN_STORYBOARD, segueId: NOTIFICATION_VCID)
    }
    @objc func EditProfile(){
        //        basicNavigation(storyName: ACCOUNT_STORYBOARD, segueId: EDIT_PROFILE)
    }
    
    func basicNavigation(storyName: String, segueId: String, withAnimation: Bool = true){
        
        let vc = UIStoryboard(name: storyName, bundle: nil).instantiateViewController(withIdentifier: segueId)
        self.navigationController?.pushViewController(vc, animated: withAnimation)
    }
    func basicPresentation(storyName: String, segueId: String, withAnimation: Bool = true){
        
        let vc = UIStoryboard(name: storyName, bundle: nil).instantiateViewController(withIdentifier: segueId)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: withAnimation, completion: nil)
    }
    func Login() {
        let vc = UIStoryboard(name: Auth_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: LOGIN_VCID)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @objc func back(){
        // move to menu
        //                self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func backUsingSWip(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func clossKeyBoard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func noInternetDialog(){
        
        let refreshAlert = UIAlertController(title: "", message:  NSLocalizedString(NO_INTERNET_CONNECTION,comment:""), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title:NSLocalizedString( "OK",comment:""), style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true)
        
        
        
        
        
    }
    func noLoginInternetDialog(){
        
        let refreshAlert = UIAlertController(title: "", message:  NSLocalizedString(NO_INTERNET_CONNECTION,comment:""), preferredStyle: UIAlertController.Style.alert)
        
        
        refreshAlert.addAction(UIAlertAction(title:NSLocalizedString( "close Weasy",comment:""), style: .default, handler: { (action: UIAlertAction!) in
            exit(0);
        }))
        
        present(refreshAlert, animated: true)
        
    }
    
    
    func checkValidPhonNumber(Phone:String  )->Bool{
        do {
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumber = try phoneNumberKit.parse(Phone)
            
            return true
            
        }
        catch {
            return false
            
        }
    }
    
    
    //set image for UIImageView
    func setImage(to image:UIImageView, from asset:String){
        if(asset == ""){
            image.image = nil
        }else{
            image.image = UIImage(named:asset)
        }
    }
    
    // custom func for present View Controller as Navigation Controller
    func presentDetail(_ viewControllerTopresent : UIViewController){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerTopresent, animated: false, completion: nil)
    }
    
    func presentSecondaryDetail(_ viewControllerTopresent : UIViewController){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        guard let presentsdViewController = presentedViewController else {return}
        presentsdViewController.dismiss(animated: false, completion: {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerTopresent, animated: false, completion: nil)
        })
        
        
    }
    
    // custom func for dismiss View Controller as Navigation Controller
    func dismissDetail(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    public func delay(_ seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
        
    }
    
    
    
    
    // Helper function inserted by Swift 4.2 migrator.
    func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    /*
     let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
     imageView.contentMode = .ScaleAspectFit
     
     let image = UIImage(named: "googlePlus")
     imageView.image = image
     
     navigationItem.titleView = imageView
     */
    
    func hideV(v:[UIView]){
        for view in v {
            view.isHidden = true
        }
    }
    
    func showV(v:[UIView]){
        for view in v {
            view.isHidden = false
        }
    }
    
    func animate_event() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func goPhone(_ num:String)
    {
        guard let number = URL(string: "telprompt://" + num) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    func play_video(url:String){
        let player = AVPlayer(url: url.toUrl)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    func goGMap(lat:Double,lng:Double){
        DispatchQueue.main.async( execute: {
//            let attributedtitle = NSAttributedString(string: "", attributes: [
////                NSAttributedString.Key.font : UIFont(name: "Almarai-Regular", size: 16.0)!
//            ])
            
//            let attributedmessage = NSAttributedString(string:"", attributes: [
////                NSAttributedString.Key.font : UIFont(name: "Almarai-Regular", size: 16.0)!
//            ])
            
            let alert = UIAlertController(title: " ", message: "",  preferredStyle: .alert)
            
//            alert.setValue(attributedtitle, forKey: "attributedTitle")
//            alert.setValue(attributedmessage, forKey: "attributedMessage")
            
            let action2 = UIAlertAction(title: "Google Maps".localize, style: .default, handler:{(alert: UIAlertAction!) in
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
                {
                    UIApplication.shared.open(NSURL(string:
                                                        "comgooglemaps://?saddr=&daddr=\(lat)),\(lng))&directionsmode=driving")! as URL)
                } else
                {
                    NSLog("Can't use com.google.maps://");
                }
            })
            
            
            alert.addAction(action2)
            let action = UIAlertAction(title: "Apple Maps".localize, style: .default, handler: {(alert: UIAlertAction!) in
                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(lat , lng)
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "Place Name".localize
                mapItem.openInMaps(launchOptions: options)
                
            })
            alert.addAction(action)
            
            let action3 = UIAlertAction(title: "Cancel".localize, style: .default, handler: {(alert: UIAlertAction!) in})
            alert.addAction(action3)
            self.present(alert,animated: true,completion: nil)
        });
        
        
    }
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    func gosite(url: String){
        if(verifyUrl(urlString: url)){
            UIApplication.shared.open(URL(string: url)!, options: [:],completionHandler: {
                (success) in print("Open")
            })
        }else{
            StaticFunctions.createErrorAlert(msg: "Wrong Link!".localize)
            
        }
    }
    
    
    func diffDates(_ dateRangeEnd:Date) -> String {
        let dateRangeStart = Date()
        print(dateRangeStart)
        print("dateRangeStart",dateRangeStart)
        //let dateRangeEnd = Date().addingTimeInterval(12345678)
        print("dateDiff ======== >", dateRangeEnd)
        return dateDiff(dateRangeStart, dateRangeEnd)
    }
    
    func dateDiff(_ dateRangeStart:Date , _ dateRangeEnd:Date) -> String {
        var result = ""
        let components = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second], from: dateRangeStart, to: dateRangeEnd)
        // print("diffrent  time  ======> ",components)
        
        if let months = components.month , let days = components.day, let hours  = components.hour , let minutes = components.minute , let seconds = components.second {
            if( months != 0){
                print(months)
                result = "\(months) \("month".localize)"
                //  return "\(months) شهر"
            }else if(days != 0){
                print(days)
                if (days % 7) > 0 {
                    let weeks =  (days % 7)
                    result = "\(weeks) \("week".localize)"
                }else{
                    result = "\(days ) \("day".localize)"
                }
                //  return "\(days ) يوم"
                
            }else if(hours != 0){
                print(hours)
                result = "\(hours) \("hours".localize)"
                //return "\(hours) ساعة"
            }else if(minutes != 0){
                print(minutes)
                result = "\(minutes) \("minutes".localize)"
                //   return "\(minutes) دقيقة"
            }else{
                print(seconds)
                result = "\(seconds) \("seconds".localize)"
                // return "\(seconds) ثانية"
            }
        }
        return result
    }
    
    func addObserver(_ str:String,_ selector:Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name:NSNotification.Name(str), object: nil)
    }
    
    func remObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func GetDateFromString(_ DateStr: String)-> Date
    {
        //2023-02-22 18:54:31
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let DateArray = DateStr.components(separatedBy: " ")
        let part1 = DateArray[0].components(separatedBy: "-")
        let part2 = DateArray[1].components(separatedBy: ":")
        
        let components = NSDateComponents()
        components.year = Int(part1[0])!
        components.month = Int(part1[1])!
        components.day = Int(part1[2])!
        components.hour = Int(part2[0])!
        components.minute = Int(part2[1])!
        //components.second = Int(part2[2].components(separatedBy: ".")[0])!
        components.second = Int(part2[2]) ?? 50
        components.timeZone = TimeZone(abbreviation: "UTC")
        let date = calendar?.date(from: components as DateComponents)
        print(date)
        return date!
    }
    
    func cDate(_ date:Date = Date(),_ format:String = "EEEE d MMMM ،  h a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        formatter.amSymbol = "ص"
        formatter.pmSymbol = "م"
        return formatter.string(from: date)
    }
    
    
    func multiLine(_ u:UITextView, _ placeHolder:String){
        u.backgroundColor = UIColor.clear
        u.textAlignment = .natural
        u.autocorrectionType = .no
        u.autocapitalizationType = .none
        u.font = UIFont(name: "Almarai-Regular", size: 14)!
        u.textColor = UIColor.black
        u.textContainerInset = UIEdgeInsets(top: 8, left: 25, bottom: 8, right: 0)
        
        let style2 = NSMutableParagraphStyle()
        style2.lineSpacing = 19
        let attributes = [NSAttributedString.Key.paragraphStyle: style2]
        u.attributedText = NSAttributedString(string: u.text!, attributes: attributes)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
//        u.attributedText = NSAttributedString(string: placeHolder,
////                                                         attributes: [.font: UIFont(name: "Almarai-Regular", size: 13.5)!,
//                                                                      .foregroundColor: UIColor.gray,.paragraphStyle: paragraphStyle
//                                                         ])
    }
    
    // Function to remove the dynamic country code
       func removeCountryCode(from phoneNumber: String) -> String {
           // Replace the dynamic country code with an empty string
           // You may need to determine the logic for identifying and removing the country code
           // In this example, we assume that the country code is the first three characters
           if phoneNumber.count >= 3 {
               let startIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
               return String(phoneNumber[startIndex...])
           } else {
               return phoneNumber
           }
       }
    
    func getViewController(_ id:String,_ story:String="Main") -> UIViewController{
        let story = UIStoryboard(name: story, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: id)
        return vc
    }
    
    func dawnloadAppFromStore(appID:String){
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
           UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func checkEmpty(cont:[UIView]) -> Bool{
        for view in cont {
            let v =  view as! UITextField
            if(v.text == nil){
                return false
            }
            if(v.text!.isEmpty){
                return false
            }
        }
        return true
    }
    
    func empty(_ txt:UITextField) -> Bool{
        guard let text = txt.text else {return false}
        return text.isEmpty ? true : false
    }
    
    func generateThumbnailImage(url:URL) -> UIImage {
           let asset = AVAsset(url: url)
           let imageGenerator = AVAssetImageGenerator(asset: asset)
           imageGenerator.appliesPreferredTrackTransform = true

           do {
               let thumbnailCGImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
               let thumbnailImage = UIImage(cgImage: thumbnailCGImage)
               return  thumbnailImage
           } catch {
               print("Failed to generate thumbnail image: \(error)")
               return UIImage()
           }
       }
    
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 37
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 1, alpha: 0.8)
        //appearance.cornerRadius = 4
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
//        appearance.shadowOpacity = 0.9
//        appearance.shadowRadius = 8
        appearance.animationduration = 0.25
        appearance.textColor = .black
        //appearance.textFont =  UIFont(name: "Almarai-Regular", size: 14)!
        appearance.textFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
}
