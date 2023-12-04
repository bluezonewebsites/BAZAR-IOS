//
//  UserBlockedVC.swift
//  NewBazar
//
//  Created by iOSayed on 23/11/2023.
//

import UIKit

class UserBlockedVC: UIViewController {
    
    
    
    static func instantiate()->UserBlockedVC{
        let controller = UIStoryboard(name: MENU_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier:"\(UserBlockedVC.self)") as! UserBlockedVC
        return controller
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var blockedUsersList = [UsersBlockedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBlockedUsers()
        
        
    }
    
    
    
    @IBAction func didTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapAddUser(_ sender: UIButton) {
        
    }
    
    func animateFirstCell() {
        guard let tableView = self.tableView else { return }

        // Ensure the first cell exists
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        // Perform animation
        UIView.animate(withDuration: 0.5, animations: {
            // Move cell to the left
            cell.transform = CGAffineTransform(translationX: -100, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.7) {
                // Move cell back to its original position
                cell.transform = CGAffineTransform.identity
            }
        }
    }
    
    
    private func getBlockedUsers(){
        UsersBlockedController.shared.getUsersBlocked(completion: {[weak self] blockedusers, check, message in
            guard let self else {return}
            if check == 0 {
                self.blockedUsersList = blockedusers
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.animateFirstCell()
                }
            }else {
                print(message)
            }
        }, userId: AppDelegate.currentUser.id ?? 0)
        
    }
    
    
}
extension UserBlockedVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserBlockedTableViewCell.self)", for: indexPath) as? UserBlockedTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        if let user = blockedUsersList[indexPath.row].blockUser{
            cell.setData(from: user )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
   
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create a UIContextualAction for each action you want to perform
        let deleteAction = UIContextualAction(style: .destructive, title: "Unblock") {[weak self] (action, view, completionHandler) in
            guard let self else {return }
            // Your code to handle the action
            // Delete the row from the table view
            ProfileController.shared.blockUser(completion: { check, message in
                if check == 0 {
                    StaticFunctions.createSuccessAlert(msg: message)
                    self.blockedUsersList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    completionHandler(true)
                }else{
                    StaticFunctions.createErrorAlert(msg: message)
                }
            }, OtherUserId: blockedUsersList[indexPath.row].id ?? 0)
          
        }
        
        // Customize the action appearance (optional)
        deleteAction.backgroundColor = .red
        
        // Return the configured UISwipeActionsConfiguration
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}
extension UserBlockedVC: UserBlockedDelegate {
    func didTapOnBlockOrUnblockButton(in cell: UserBlockedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        ProfileController.shared.blockUser(completion: {[weak self] check, message in
            guard let self else {return}
            if check == 0 {
                StaticFunctions.createSuccessAlert(msg: message)
                getBlockedUsers()
            }else{
                StaticFunctions.createErrorAlert(msg: message)
            }
        }, OtherUserId: blockedUsersList[indexPath.row].toUid ?? 0)
    }
}


