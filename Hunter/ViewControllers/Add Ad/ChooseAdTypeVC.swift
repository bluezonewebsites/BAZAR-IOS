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
    @IBOutlet weak var countOfPaidAdsLabel: UILabel!
    @IBOutlet weak var costOfFeaturedAdsLabel: UILabel!
    
    //MARK: PROPERTIES
    
    weak var delegate:ChooseAdTyDelegate?
    
    var countPaidAds = Constants.countPaidAds
    override func viewDidLoad() {
        super.viewDidLoad()

        if AppDelegate.currentUser.isStore ?? false && MOLHLanguage.isArabic(){
            costOfFeaturedAdsLabel.text = "\(AppDelegate.sharedSettings.storePriceFeaturedAds ?? 0.0) " + AppDelegate.sharedCountry.currencyAr.safeValue
            countOfPaidAdsLabel.text = "\(AppDelegate.sharedSettings.storePriceNormalAds ?? 0.0) " + AppDelegate.sharedCountry.currencyAr.safeValue
        }else {
            countOfPaidAdsLabel.text = "\(AppDelegate.sharedSettings.userPriceNormalAds ?? 0.0) " + AppDelegate.sharedCountry.currencyEn.safeValue
            costOfFeaturedAdsLabel.text = "\(AppDelegate.sharedSettings.userPriceFeaturedAds ?? 0.0) " + AppDelegate.sharedCountry.currencyEn.safeValue

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
