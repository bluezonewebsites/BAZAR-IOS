//
//  CityViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//

import UIKit
import MOLH

class CityViewController: UIViewController {
    
    @IBOutlet weak var cityLbl: UILabel!
    var cityBtclosure : (( Int, String) -> Void)? = nil
    var cityId = -1
    var countryId = -1
    var cityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCities()
        // Do any additional setup after loading the view.
    }
    @IBAction func backToAllAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.cityBtclosure!(-1, "choose city".localize)
            
            
        })
        
    }
    @IBAction func applyAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.cityBtclosure!(self.cityId, self.cityName)
            
            
        })
    }
    @IBAction func closeActoin(_ sender: Any) {
        self.dismiss(animated: false)
        
    }
    @IBAction func choseCityActiion(_ sender: Any) {
//        self.dismiss(animated: false, completion: {
            
            let vc = UIStoryboard(name: MAIN_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: CITIES_VCIID) as!  CitiesViewController
            vc.countryId = self.countryId
            vc.citiesBtclosure = {
                (city) in
               var name =  MOLHLanguage.currentAppleLanguage() == "en" ? (city.nameEn ?? "") : (city.nameAr ?? "")
                self.cityId = city.id ?? 0
                self.cityLbl.text = name
                self.cityName = name
            }
            self.present(vc, animated: true, completion: nil)
            
//        }
//    )
        
        
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
extension CityViewController{
    func getCities(){
        CountryController.shared.getCities(completion: {
            cities, check,msg in
            Constants.CITIES = cities
        }, countryId: countryId)
    }
}
