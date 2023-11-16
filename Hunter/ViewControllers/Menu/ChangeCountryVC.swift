//
//  ChangeCountryVC.swift
//  Bazar
//
//  Created by iOSayed on 03/06/2023.
//
import UIKit
import MOLH

class ChangeCountryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var counties = [Country]()
    var countryBtclosure : (( Country) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        counties = Constants.COUNTRIES

        if Constants.COUNTRIES.count == 0{
            getCounties()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back".localize,
                style: .plain,
                target: nil,
                action: nil
            )
            
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
extension ChangeCountryVC{
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
extension ChangeCountryVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counties.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeCountyTableViewCell", for: indexPath) as! ChangeCountyTableViewCell
        if counties[indexPath.row].id == AppDelegate.currentUser.countryId {
            cell.checkImageView.isHidden = false
        }
        cell.setData(country: counties[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.currentCountry = counties[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name("changeCountryName"), object: nil)
        Constants.countryId = counties[indexPath.row].id ?? 6
        self.navigationController?.popViewController(animated: true)
    }
}
