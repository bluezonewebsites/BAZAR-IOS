//
//  CounriesViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//

import UIKit
import MOLH

class CounriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var counties = [Country]()
    var countryBtclosure : (( Country) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        counties = Constants.COUNTRIES

        if Constants.COUNTRIES.count == 0{
            getCounties()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false)
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
extension CounriesViewController{
    func getCounties(){
        CountryController.shared.getCountries(completion: {
            countries, check,msg in
            self.counties = countries
            Constants.COUNTRIES = countries
            print(self.counties.count)
            self.tableView.reloadData()
           
        })
    }
}
extension CounriesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counties.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        cell.setData(country: counties[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: { [self] in
            self.countryBtclosure!(counties[indexPath.row])
            
            //counties[indexPath.row].id, MOLHLanguage.currentAppleLanguage() == "en" ? (counties[indexPath.row].nameEn ?? "") : (counties[indexPath.row].nameAr ?? ""), counties[indexPath.row].code
        })
    }
}
