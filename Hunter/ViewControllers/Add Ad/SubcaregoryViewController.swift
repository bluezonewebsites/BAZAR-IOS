//
//  SubcaregoryViewController.swift
//  NewBazar
//
//  Created by Amal Elgalant on 16/11/2023.
//

import UIKit

class SubcaregoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var categoryId = 0
    var categories = [Category]()
    var categoryBtclosure : (( Category) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategory()
        
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
extension SubcaregoryViewController{
    
    func getCategory(){
       
        CategoryController.shared.getSubCategories(completion: {
            categories, check, msg in
            
            self.categories = categories
            self.tableView.reloadData()
            
        }, categoryId: self.categoryId)
        
    }
    
}
extension SubcaregoryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        cell.setData(category: categories[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: { [self] in
            self.categoryBtclosure!(categories[indexPath.row])
            
            //counties[indexPath.row].id, MOLHLanguage.currentAppleLanguage() == "en" ? (counties[indexPath.row].nameEn ?? "") : (counties[indexPath.row].nameAr ?? ""), counties[indexPath.row].code
        })
    }
}
