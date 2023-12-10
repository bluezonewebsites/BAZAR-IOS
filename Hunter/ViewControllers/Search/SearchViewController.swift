//
//  SearchViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 18/05/2023.
//

import UIKit
protocol ContentDelegate {
    func updateContent(searchText: String, isHidden: Bool)
}
class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var personLbl: UILabel!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var adsLbl: UILabel!
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var peresonView: UIView!
    @IBOutlet weak var questionsView: UIView!
    var searchText = ""
    var delegate: ContentDelegate?
    var delegate1: ContentDelegate?
    var delegate2: ContentDelegate?
    var isHidden = false
    @IBOutlet weak var topTabsBar: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)
        navigationController?.navigationBar.isHidden = true
        
        searchBar.text = searchText
        self.delegate?.updateContent(searchText: searchText, isHidden: isHidden)
        self.delegate1?.updateContent(searchText: searchText, isHidden: isHidden)
        self.delegate2?.updateContent(searchText: searchText, isHidden: isHidden)
        //                tabsBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("hideTabBar"), object: nil)

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
//        searchBar.text = ""
//        self.navigationController?.popToRootViewController(animated: true)
//        NotificationCenter.default.post(name: NSNotification.Name("ShowTabBar"), object: nil)

        
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func adsBtnAction(_ sender: Any) {
        adsLbl.textColor = UIColor(named: "#0093F5")
        adsView.backgroundColor = UIColor(named: "#0093F5")
        
        personLbl.textColor = .black
        personView.backgroundColor = UIColor(named: "#929292")
        
        questionLbl.textColor = .black
        questionView.backgroundColor = UIColor(named: "#929292")
        
        adView.isHidden = false
        peresonView.isHidden = true
        questionsView.isHidden = true
        
    }
    @IBAction func personsBtnAction(_ sender: Any) {
        adsLbl.textColor = .black
        adsView.backgroundColor = UIColor(named: "#929292")
        
        personLbl.textColor = UIColor(named: "#0093F5")
        personView.backgroundColor = UIColor(named: "#0093F5")
        
        questionLbl.textColor = .black
        questionView.backgroundColor = UIColor(named: "#929292")
        
        adView.isHidden = true
        peresonView.isHidden = false
        questionsView.isHidden = true
    }
    @IBAction func questionsBtnAction(_ sender: Any) {
        adsLbl.textColor = .black
        adsView.backgroundColor = UIColor(named: "#929292")
        
        personLbl.textColor = .black
        personView.backgroundColor = UIColor(named: "#929292")
        
        questionLbl.textColor = UIColor(named: "#0093F5")
        questionView.backgroundColor = UIColor(named: "#0093F5")
        
        adView.isHidden = true
        peresonView.isHidden = true
        questionsView.isHidden = false
    }
    
    /*
     // MARK: - Navigation
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ads" {
            if let firstChildCV = segue.destination as? SearchAdsViewController {
                self.delegate = firstChildCV
                //Access your child VC elements
            }
        }
        if segue.identifier == "persons"{
            if let secondChildCV = segue.destination as? SearchPersonViewController {
                self.delegate1 = secondChildCV
                
                //Access your child VC elements
            }
        }
        if segue.identifier == "questions"{
            if let secondChildCV = segue.destination as? SearchAskViewController {
                self.delegate2 = secondChildCV
                
                //Access your child VC elements
            }
        }
        
    }
}
extension SearchViewController: UISearchBarDelegate{
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        NSObject.cancelPreviousPerformRequests(
    //            withTarget: self,
    //            selector: #selector(self.getHintsFromTextField),
    //            object: searchBar)
    //        self.perform(
    //            #selector(self.getHintsFromTextField),
    //            with: searchBar,
    //            afterDelay: 0.5)
    //
    //        self.searchText = searchText
    //
    //    }
    //    @objc func getHintsFromTextField(searchBar: UISearchBar) {
    //        self.searchText = searchBar.text!
    //
    //        self.delegate?.updateContent(searchText: searchText, isHidden: isHidden)
    //        self.delegate1?.updateContent(searchText: searchText, isHidden: isHidden)
    //        self.delegate2?.updateContent(searchText: searchText, isHidden: isHidden)
    //
    //    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        topTabsBar.isHidden = false
        isHidden = false
        self.searchText = searchBar.text!
        
    //new part
        adsLbl.textColor = UIColor(named: "#0093F5")
        adsView.backgroundColor = UIColor(named: "#0093F5")
        
        personLbl.textColor = UIColor(named: "#929292")
        personView.backgroundColor = UIColor(named: "#929292")
        
        questionLbl.textColor = UIColor(named: "#929292")
        questionView.backgroundColor = UIColor(named: "#929292")
        //new part
        adView.isHidden = false
        peresonView.isHidden = true
        questionsView.isHidden = true
        self.delegate?.updateContent(searchText: searchText, isHidden: isHidden)
        self.delegate1?.updateContent(searchText: searchText, isHidden: isHidden)
        self.delegate2?.updateContent(searchText: searchText, isHidden: isHidden)
    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        topTabsBar.isHidden = false
//        isHidden = false
//        self.searchText = searchBar.text!
//
//    //new part
//        adsLbl.textColor = UIColor(named: "#0093F5")
//        adsView.backgroundColor = UIColor(named: "#0093F5")
//
//        personLbl.textColor = UIColor(named: "#929292")
//        personView.backgroundColor = UIColor(named: "#929292")
//
//        questionLbl.textColor = UIColor(named: "#929292")
//        questionView.backgroundColor = UIColor(named: "#929292")
//        //new part
//        adView.isHidden = false
//        peresonView.isHidden = true
//        questionsView.isHidden = true
//        self.delegate?.updateContent(searchText: searchText, isHidden: isHidden)
//        self.delegate1?.updateContent(searchText: searchText, isHidden: isHidden)
//        self.delegate2?.updateContent(searchText: searchText, isHidden: isHidden)
//    }
}
