//
//  ProdSpecialCell.swift
//  Bazar
//
//  Created by khaled on 21/05/2022.
//  Copyright © 2022 roll. All rights reserved.
//

import UIKit
import AVFoundation

class MsgRecordCell: MsgGlobalCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var ext: UILabel!
    @IBOutlet weak var btn_play: UIButton!
    

    var audioPlayer : AVPlayer!
    override func awakeFromNib() {
        container.apply_right_bubble()
        
        
        

    }
    
    override func configure(data:Result) {
//        if data.rid == AppDelegate.currentUser.id {
//            container.backgroundColor = .gray
//        }else {
//            container.backgroundColor =  UIColor(named: "#0093F5")
//        }
        
        if let url =  data.image {
            playAudioFromURL("\(Constants.IMAGE_URL)\(url)")
        }
        
    }
    
    private func playAudioFromURL(_ url:String) {
        guard let url = URL(string: url) else {
            return
        }
        audioPlayer = AVPlayer(url: url as URL)
        let duration = Int(audioPlayer.currentItem!.asset.duration.seconds)
        lbl_duration.text = "\(duration) sec"
        
//        if audioPlayer.isPlaying == false {
//            audioPlayer?.play()
//            img.image = UIImage(named: "play_green_icon")
//
//        }else {
//            audioPlayer?.pause()
//            img.image = UIImage(named: "Pause")
//
//        }
    }
}



