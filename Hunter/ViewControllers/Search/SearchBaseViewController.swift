//
//  SearchBaseViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 21/07/2023.
//

import UIKit

class SearchBaseViewController: UIViewController {
    var searchText = ""

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.emptySearchText(_:)), name: NSNotification.Name(rawValue: "emptySearchText"), object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func emptySearchText(_ notification: NSNotification) {
        searchBar.text = ""

        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
        
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
extension SearchBaseViewController: UISearchBarDelegate{
  
    @objc func getHintsFromTextField(searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        
       
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.searchText = searchBar.text!
        if self.searchText != ""{
            let vc = UIStoryboard(name: SEARCH_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: SEARCH_VCID) as! SearchViewController
            vc.searchText = self.searchText
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.searchText = searchBar.text!
//        if self.searchText != ""{
//            let vc = UIStoryboard(name: SEARCH_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: SEARCH_VCID) as! SearchViewController
//            vc.searchText = self.searchText
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//       
//    }
}
