//
//  TypeViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 29/04/2023.
//

import UIKit

class TypeViewController: UIViewController {
    var typeBtclosure : (( Int?,String) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func allAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(nil, "All".localize)

        })

    }
    @IBAction func rentAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(1,"Rent".localize)

        })
        
    }
    @IBAction func sellAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.typeBtclosure!(0, "Sell".localize)

        })
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
