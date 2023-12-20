//
//  CitiesViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//

import UIKit
import MOLH

class CitiesViewController: BottomPopupViewController {
    var citiesBtclosure : (( Country) -> Void)? = nil
    var cities = [Country]()

    var countryId = -1

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cities = Constants.CITIES

//        if Constants.CITIES.count == 0{
            getCities()
//        }

        // Do any additional setup after loading the view.
    }
    
    override func getPopupHeight() -> CGFloat {
        return 500
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 25
    }
    
    override func getPopupPresentDuration() -> Double {
        0.3
    }
    
    override func getPopupDismissDuration() -> Double {
        0.3
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        true
    }
    
    override func getDimmingViewAlpha() -> CGFloat {
        0.7
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)

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
extension CitiesViewController{
    func getCities(){
        CountryController.shared.getCities(completion: {
            cities, check,msg in
            self.cities = cities
            Constants.CITIES = cities
            self.tableView.reloadData()
          
        }, countryId: countryId)
    }
}
extension CitiesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        cell.setData(country: cities[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: { [self] in
            self.citiesBtclosure!(cities[indexPath.row])
        })
    }
}
