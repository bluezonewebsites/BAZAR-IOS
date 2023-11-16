//
//  StateViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 01/05/2023.
//

import UIKit
import MOLH
class StateViewController: UIViewController {
    
    var citiesBtclosure : (( Country) -> Void)? = nil
    var cities = [Country]()
    
    var countryId = -1
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cities = Constants.STATUS
        
//        if Constants.STATUS.count == 0{
            getCities()
//        }else{
//          
//        }
        
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
extension StateViewController{
    func getCities(){
        CountryController.shared.getStates(completion: {
            cities, check,msg in
            self.cities = cities
            Constants.STATUS = cities
            self.tableView.reloadData()
        }, countryId: countryId)
    }
}
extension StateViewController: UITableViewDataSource, UITableViewDelegate{
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
