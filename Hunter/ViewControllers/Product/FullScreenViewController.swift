//
//  FullScreenViewController.swift
//  Bazar
//
//  Created by Amal Elgalant on 10/07/2023.
//

import UIKit
import MediaSlideshow

class FullScreenViewController: UIViewController {
    @IBOutlet weak var imageSlider: MediaSlideshow!
    var dataSource = ImageAndVideoSlideshowDataSource(sources:[
        
        
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()

        // Do any additional setup after loading the view.
    }

    func setupSlider(){
        imageSlider.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
        imageSlider.contentScaleMode = .scaleToFill
//        imageSlider.slideshowInterval = 2
        imageSlider.zoomEnabled = true
        imageSlider.preload = .all
        imageSlider.dataSource = dataSource
        imageSlider.reloadData()


        

    }
    @IBAction func closeBtnAction(_ sender: Any) {
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
