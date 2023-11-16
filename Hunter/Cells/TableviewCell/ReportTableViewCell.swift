//
//  ReportTableViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 17/05/2023.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var reasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func seetData(reason:String){
        reasonLabel.text = reason
    }

}
