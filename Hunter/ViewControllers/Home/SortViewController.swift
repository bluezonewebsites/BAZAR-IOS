//
//  SortViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 25/04/2023.
//

import UIKit
import DLRadioButton

class SortViewController: UIViewController {
    
    @IBOutlet weak var lowestPriceAction: UIStackView!
    @IBOutlet weak var highestPriceAction: UIStackView!
    @IBOutlet weak var latestPrceAction: UIStackView!
    @IBOutlet weak var latestRadio: DLRadioButton!
    
    @IBOutlet weak var lowestRadio: DLRadioButton!
    @IBOutlet weak var highestRadio: DLRadioButton!
    
    var sortBtclosure : (( String) -> Void)? = nil
    var type = "newest"
    override func viewDidLoad() {
        super.viewDidLoad()
        latestRadio.otherButtons = [lowestRadio, highestRadio]
        if type == "newest"{
            latestRadio.isSelected = true
        }else if type == "high_price"{
            highestRadio.isSelected = true
            
        }else{
            lowestRadio.isSelected = true
            
        }
        let gesturelatest = UITapGestureRecognizer(target: self, action:  #selector( self.latestAction))
        self.latestPrceAction.addGestureRecognizer(gesturelatest)
        
        let gestureHighest = UITapGestureRecognizer(target: self, action:  #selector(self.highestAction))
        self.highestPriceAction.addGestureRecognizer(gestureHighest)
        
        let gestureLoweest = UITapGestureRecognizer(target: self, action:  #selector(self.lowestAction))
        self.lowestPriceAction.addGestureRecognizer(gestureLoweest)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ApplyAction(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.sortBtclosure!(self.type)
        })
        
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
    @objc func latestAction(sender : UITapGestureRecognizer) {
        type = "newest"
        latestRadio.isSelected = true

        // Do what you want
    }
    @objc func highestAction(sender : UITapGestureRecognizer) {
        type = "high_price"
        
        highestRadio.isSelected = true

        // Do what you want
    }
    @objc func lowestAction(sender : UITapGestureRecognizer) {
        type = "low_price"
        lowestRadio.isSelected = true

        // Do what you want
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
