//
//  ProductCollectionViewCell.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/04/2023.
//

import UIKit
import MOLH
import SDWebImage
import Kingfisher
class ProductCollectionViewCell: UICollectionViewCell {
    
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var currencuLbl: UILabel!
    @IBOutlet weak var featuredImageIcon: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var sellView: UIView!
    //    @IBOutlet weak var listStackViewContainer: UIStackView!
    //
    //    @IBOutlet weak var listViewContsiner: UIView!
    @IBOutlet weak var videoIcone: UIImageView!
    @IBOutlet weak var subscribeImage: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var sellLbl: UILabel!
    //    @IBOutlet weak var timeLabelList: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    //    @IBOutlet weak var gridTimeLabel: UILabel!
    
    func setData(product: Product){
        
        nameLbl.text = product.name
        priceLbl.text = "\(product.price ?? 0)"
        
        if  MOLHLanguage.currentAppleLanguage() == "en" {
            currencuLbl.text = product.currencyEn
            cityLbl.text = product.cityNameEn
            
        }else{
            currencuLbl.text = product.currencyAr
            cityLbl.text = product.cityNameAr
            
        }
        
        ownerName.text = "\(product.userName ?? "") \(product.userLastName ?? "")"
        
        
        if product.userVerified == 1{
            subscribeImage.isHidden = false
        }else{
            subscribeImage.isHidden = true
        }
        
        if let tajeerOrSell = product.type  {
            print(tajeerOrSell)
            if( tajeerOrSell == 1){
                sellLbl.text = "rent".localize
                sellLbl.textColor = .black
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor.black.cgColor
                sellView.clipsToBounds = true
                sellView.backgroundColor = .white
            }else{
                sellLbl.text = "sell".localize
                sellView.layer.borderWidth = 1.0
                sellView.layer.borderColor = UIColor(named: "#0093F5")?.cgColor
                sellView.clipsToBounds = true
                sellLbl.textColor = .white
                sellView.backgroundColor = UIColor(named: "#0093F5")
            }
            
            
            
        }
        if let createDate = product.createdAt{
//            if createDate.count > 11 {
////                self.timeLbl.text =  "\(createDate[11..<16])"
//                self.timeLbl.text = diffDates(GetDateFromString(createDate)).replace("-", "")
//            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let pastDate = dateFormatter.date(from:createDate ) ?? Date()
            
            self.timeLbl.text = pastDate.timeAgoDisplay()
            
        }
        
        var imageLink = ""
        if product.mainImage == "" {
             imageLink = product.image ?? ""
        }else{
             imageLink = product.mainImage ?? ""
        }
        
       
        
        if imageLink.contains(".mp4")  || imageLink.contains(".mov") {

            imageView.kf.indicatorType = .activity

            guard let url = URL(string: Constants.IMAGE_URL + imageLink) else { return }
            self.imageView.kf.setImage(with: AVAssetImageDataProvider(assetURL: url, seconds: 1))
            videoIcone.isHidden = false

            
        }else{
            videoIcone.isHidden = true
            imageView.setImageWithLoading(url: imageLink )
 
        }
        print(product.isFeature)
        
        featuredImageIcon.isHidden = !(product.isFeature ?? false)
        
    }
   
}
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

extension UIView{
    
    func diffDates(_ dateRangeEnd:Date) -> String {
        let dateRangeStart = Date()
        return dateDiff(dateRangeStart, dateRangeEnd)
    }
    func GetDateFromString(_ DateStr: String)-> Date
    {
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
        components.second = Int(part2[2].components(separatedBy: ".")[0])!
        components.timeZone = TimeZone(abbreviation: "UTC")
        let date = calendar?.date(from: components as DateComponents)
        
        return date!
    }
    
    func GetDateFromStringLocalizable(_ DateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the date format based on your input DateStr format
        dateFormatter.locale = Locale(identifier: MOLHLanguage.currentAppleLanguage()) // Use the app's current language
        
        let date = dateFormatter.date(from: DateStr) ?? Date()
        return date
    }
    func dateDiff(_ dateRangeStart:Date , _ dateRangeEnd:Date) -> String {
        var result = ""
        let components = Calendar.current.dateComponents([.month,.day,.hour,.minute,.second], from: dateRangeStart, to: dateRangeEnd)
        // print("diffrent  time  ======> ",components)
        
        if let months = components.month , let days = components.day, let hours  = components.hour , let minutes = components.minute , let seconds = components.second {
            if( months != 0){
                print(months)
                result = "\("before".localize) \(months) \("month".localize)"
                //  return "\(months) شهر"
            }else if(days != 0){
                print(days)
                if (days % 7) > 0 {
                    let weeks =  (days % 7)
                    result = "\("before".localize) \(weeks) \("week".localize)"
                }else{
                    result = "\("before".localize) \(days ) \("day".localize)"
                }
                //  return "\(days ) يوم"
                
            }else if(hours != 0){
                print(hours)
                result = "\("before".localize) \(hours) \("hours".localize)"
                //return "\(hours) ساعة"
            }else if(minutes != 0){
                print(minutes)
                result = "\("before".localize) \(minutes) \("minutes".localize)"
                //   return "\(minutes) دقيقة"
            }else{
                print(seconds)
                result = "\("before".localize) \(seconds) \("seconds".localize)"
                // return "\(seconds) ثانية"
            }
        }
        return result
    }
    func cDate(_ date:Date = Date(),_ format:String = "EEEE d MMMM ،  h a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = NSLocale(localeIdentifier: "ar") as Locale
        formatter.amSymbol = "ص"
        formatter.pmSymbol = "م"
        return formatter.string(from: date)
    }
}
