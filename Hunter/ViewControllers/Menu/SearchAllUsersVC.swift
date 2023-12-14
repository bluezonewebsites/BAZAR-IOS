//
//  SearchAllUsersVC.swift
//  NewBazar
//
//  Created by iOSayed on 13/12/2023.
//

import UIKit

protocol SearchAllUserDelegate:AnyObject{
    func didblockedUser()
}

class SearchAllUsersVC: UIViewController,UISearchBarDelegate {

    static func instantiate()->SearchAllUsersVC{
        let controller = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"SearchAllUsersVC") as! SearchAllUsersVC
        return controller
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate:SearchAllUserDelegate?
    var users = [User]()
    var page = 1
    var isTheLast = false
    var searchText = ""
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var searchNoResult: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //        getData()
        navigationController?.navigationBar.isHidden = true
        
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.searchText = searchText
            getData()
        }
    }

    @IBAction func didTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension SearchAllUsersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell") as! UserSearchCell
        cell.setData(user: users[indexPath.row])
        if StaticFunctions.isLogin() {
            cell.blockBtclosure = {
               //block user
                ProfileController.shared.blockUser(completion: {[weak self] check, message in
                    guard let self else {return}
                    if check == 0 {
                        StaticFunctions.createSuccessAlert(msg: message)
                        delegate?.didblockedUser()
                        getData()
                    }else{
                        StaticFunctions.createErrorAlert(msg: message)
                    }
                }, OtherUserId: self.users[indexPath.row].id ?? 0)

            }
        }else{
            StaticFunctions.createErrorAlert(msg: "Please Login First".localize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.basicPresentation(storyName: Auth_STORYBOARD, segueId: "login_nav")
            }
            
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: PROFILE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: OTHER_USER_PROFILE_VCID) as! OtherUserProfileVC
        vc.navigationController?.navigationBar.isHidden = true
        vc.OtherUserId = users[indexPath.row].id ?? 0
        print(users[indexPath.row].id ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (users.count-1) && !isTheLast{
            page+=1
            getData()
            
        }
    }
    
    
}

extension SearchAllUsersVC{
    func getData(){
        SearchController.shared.searchPerson(completion: {
            users, check, msg in
            if check == 0{
                if self.page == 1 {
                    
                    self.users.removeAll()
                    self.tableView.reloadData()
                    
                    self.users = users
                    
                }else{
                    self.users.append(contentsOf: users)
                }
                if users.isEmpty{
                    self.page = self.page == 1 ? 1 : self.page - 1
                    self.isTheLast = true
                }
                if self.users.count == 0{
                    self.searchNoResult.isHidden = false
                }else{
                    self.searchNoResult.isHidden = true
                }
                self.tableView.reloadData()
            }else{
                StaticFunctions.createErrorAlert(msg: msg)
                self.page = self.page == 1 ? 1 : self.page - 1
            }
        }, id: AppDelegate.currentUser.id ?? 0, searchText: searchText, page: self.page,countryId:AppDelegate.currentCountry.id ?? 0)
    }
}
//extension SearchPersonViewController: ContentDelegate{
//    func updateContent(searchText: String, isHidden: Bool) {
//        print(searchText)
//        self.searchText = searchText
//        self.page = 1
//        self.isTheLast = false
//        textStackView.isHidden = isHidden
//        self.tableView.isHidden = isHidden
//
//        getData()
//    }
//    
//    
//}

