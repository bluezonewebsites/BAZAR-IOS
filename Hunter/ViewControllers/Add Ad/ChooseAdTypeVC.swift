//
//  ChooseAdTypeVC.swift
//  Bazar
//
//  Created by iOSayed on 06/09/2023.
//

import UIKit
import Alamofire


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

        countOfPaidAdsLabel.text = "You have ".localize + " (\(countPaidAds)) " + " Paid ads".localize
    }
    

    // MARK: - IBACtions
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        
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
