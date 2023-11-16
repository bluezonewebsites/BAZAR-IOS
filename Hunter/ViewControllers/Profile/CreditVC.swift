//
//  CreditViewController.swift
//  Bazar
//
//  Created by iOSayed on 10/08/2023.
//

import Foundation
import UIKit

class CreditVC:UIViewController {
    
// MARK: - OUTLETS
    
    @IBOutlet private var currancyLabel: [UILabel]!
    
    @IBOutlet weak var paidCreditLabel: UILabel!
    @IBOutlet weak var freeCreditLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
}
