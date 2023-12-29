//
//  ChooseAdTypeVC.swift
//  Bazar
//
//  Created by iOSayed on 06/09/2023.
//

import UIKit
import Alamofire
import MOLH


protocol ChooseAdTyDelegate:AnyObject{
    func didTapNormalAd()
    func didTapFeaturedAd()
}

class ChooseAdTypeVC: UIViewController {

    //MARK:  IBOutlets
    @IBOutlet private weak var countOfPaidAdsLabel: UILabel!
    @IBOutlet private weak var costOfFeaturedAdsLabel: UILabel!
    
    //MARK: PROPERTIES
    
    weak var delegate:ChooseAdTyDelegate?
    
    var countPaidAds = Constants.countPaidAds
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        if AppDelegate.currentUser.isStore ?? false && MOLHLanguage.isArabic(){
            if AppDelegate.currentUser.availableAdsCountStoreInCurrentMonth.safeValue <= 0 {
                costOfFeaturedAdsLabel.text = "\(AppDelegate.sharedSettings.storePriceFeaturedAds ?? 0.0) " + AppDelegate.sharedCountry.currencyAr.safeValue
                countOfPaidAdsLabel.text = "\(AppDelegate.sharedSettings.storePriceNormalAds ?? 0.0) " + AppDelegate.sharedCountry.currencyAr.safeValue
            }else {
                costOfFeaturedAdsLabel.text = "\(AppDelegate.sharedSettings.storePriceFeaturedAds ?? 0.0) " + AppDelegate.sharedCountry.currencyAr.safeValue
                countOfPaidAdsLabel.text = "You have ".localize + "\(AppDelegate.currentUser.availableAdsCountStoreInCurrentMonth.safeValue)" + " Paid ads".localize
            }
          
        }else {
            if AppDelegate.currentUser.availableAdsCountUserInCurrentMonth.safeValue <= 0 {
                countOfPaidAdsLabel.text = "\(AppDelegate.sharedSettings.userPriceNormalAds ?? 0.0) " + AppDelegate.sharedCountry.currencyEn.safeValue
                costOfFeaturedAdsLabel.text = "\(AppDelegate.sharedSettings.userPriceFeaturedAds ?? 0.0) " + AppDelegate.sharedCountry.currencyEn.safeValue
            }else {
                costOfFeaturedAdsLabel.text = "\(AppDelegate.sharedSettings.storePriceFeaturedAds ?? 0.0) " + AppDelegate.sharedCountry.currencyAr.safeValue
                countOfPaidAdsLabel.text = "You have ".localize + " \(AppDelegate.currentUser.availableAdsCountUserInCurrentMonth.safeValue)" + " Paid ads".localize
            }
           

        }
        
    }
    
    
    

    // MARK: - IBACtions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func didTapChooseFeaturedAdButton(_ sender: UIButton) {
        delegate?.didTapFeaturedAd()
        dismiss(animated: true)
    }
    
    @IBAction func didTapNormalAdButton(_ sender: Any) {
        delegate?.didTapNormalAd()
        dismiss(animated: true)
    }
    

}
