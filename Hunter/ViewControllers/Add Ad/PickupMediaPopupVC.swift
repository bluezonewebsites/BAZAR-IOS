//
//  PickupMediaPopupVC.swift
//  Bazar
//
//  Created by iOSayed on 01/05/2023.
//

import UIKit
import PhotosUI
import MobileCoreServices

protocol PickupMediaPopupVCDelegate: AnyObject {
    func PickupMediaPopupVC(_ controller: PickupMediaPopupVC, didSelectImages images: [String:UIImage] , mediaKeys:[String] , selectedMedia:[String:Data])
}

class PickupMediaPopupVC: UIViewController {
 
    weak var delegate: PickupMediaPopupVCDelegate?
    var images = [String:UIImage]()
    var mediaKeys = [String]()
    var selectedMedia = [String:Data]()
    var imagesIndex = [String]()
    
    //MARK: App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    //MARK: IBActions
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        print("closeBtnAction")
        dismiss(animated: false)
        
    }
    
    @IBAction func openGalleryBtnAction(_ sender: UIButton) {
        print("openGalleryBtnAction")
        openGallery()
        //dismiss(animated: true)
        
        
    }
    
    @IBAction func openVideosBtnAction(_ sender: UIButton) {
        print("openVideosBtnAction")
        openVideoGallery()
        
    }
    
    @IBAction func openCameraBtnAction(_ sender: UIButton) {
        print("openCameraBtnAction")
        openCamera(isRecordVideo: false)

    }
    
    @IBAction func recordVideoBtnAction(_ sender: UIButton) {
        print("recordVideoBtnAction")
        openCamera(isRecordVideo: true)
    }
    
}
extension PickupMediaPopupVC : PHPickerViewControllerDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
       
        // empty the images Array
//        images = []
//        selectedMedia = [:]
        print(results)
        for (_,result) in results.enumerated() {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    print( "Fooo ",image)
                    let data = image.jpegData(compressionQuality: 0.01)
                    let newImage = UIImage(data: data!)
                    let index = UUID().uuidString
                    print(index)
                    self.images["IMAGE \(index)"] = newImage! as UIImage
//                    let index = self.images.count - 1
                    self.selectedMedia["IMAGE \(index)"] = data
//                    guard let index = self.images.firstIndex(of: newImage!) else {return}
//                    self.selectedMedia.updateValue(data!, forKey: "IMAGE \(index)")
                }
                DispatchQueue.main.async {
                    self.delegate?.PickupMediaPopupVC(self, didSelectImages: self.images,mediaKeys: self.mediaKeys,selectedMedia: self.selectedMedia)
                    self.dismiss(animated: false)
                }
            }
            
        }
        
        
        dismiss(animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true, completion: nil)
            
        let dispatchGroup = DispatchGroup()

        if let mediaURL = info[.mediaURL] as? URL {
                   print("Captured video URL: \(mediaURL)")
            //Compress Video
            
            
            do {
                let index = UUID().uuidString
                picker.videoQuality = .typeMedium
                let data = try Data(contentsOf: mediaURL, options: .mappedIfSafe)
                print(mediaURL)
                //compress
                let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mp4")
                var compressedVideo : Data? =  nil
                
                dispatchGroup.enter()
                // Encode to mp4
                compressVideo(inputURL: mediaURL, outputURL: compressedURL, handler: { [weak self] (_ exportSession: AVAssetExportSession?) -> Void in
                                    guard let self = self else {return}


                    defer {
                                       dispatchGroup.leave()
                                   }
                                   
                    switch exportSession!.status {
                        case .completed:

                        print("Video compressed successfully")
                        do {
                            compressedVideo = try Data(contentsOf: exportSession!.outputURL!)
                            print(compressedVideo)
                            guard let compressedVideo = compressedVideo else{return}
                             
                            self.selectedMedia.updateValue(compressedVideo, forKey: "VIDEO \(index)")
                            self.imagesIndex.append("VIDEO \(index)")
                            self.mediaKeys.append("VIDEO \(index)")

                            
                        } catch let error {
                            print ("Error converting compressed file to Data", error)
                        }

                        default:
                            print("Could not compress video")
                    }
                } )
                
                // end of compress
                let videoThumbnil = self.generateThumbnail(path: mediaURL)
                guard let videoThumbnil = videoThumbnil else{return}
                // pass video as image to images[]
//                self.images.append(videoThumbnil as UIImage)
                self.images["VIDEO \(index)"] = videoThumbnil
                
           
            } catch let error {
                print(error)
            }

            
               } else if let capturedImage = info[.originalImage] as? UIImage {
                   print("Captured image: \(capturedImage)")
//                   self.images.append(capturedImage as UIImage)
                   let index = UUID().uuidString
                   self.images["IMAGE \(index)"] = capturedImage
                   
                   
                   guard let imageData = capturedImage.jpegData(compressionQuality: 0.01) else {
                       print("Error converting image to data")
                       return}
//                   guard let index = self.images.firstIndex(of: capturedImage) else {return}
                   
                   self.mediaKeys.append("IMAGE \(index)")
                   self.selectedMedia.updateValue(imageData, forKey: "IMAGE \(index)")
                   self.imagesIndex.append("IMAGE \(index)")
//                   DispatchQueue.main.async {
//                       self.delegate?.PickupMediaPopupVC(self, didSelectImages: self.images,videos: self.videos,selectedMedia: self.selectedMedia)
//                                       self.dismiss(animated: false)
//                   }
               }
               
        dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                print(self.imagesIndex)
                self.delegate?.PickupMediaPopupVC(self, didSelectImages: self.images,mediaKeys: self.mediaKeys,selectedMedia: self.selectedMedia)
                self.dismiss(animated: false)
            }
        }
        
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
    


@available(iOS 14.0, *)
extension PickupMediaPopupVC {
    
    //MARK: Methods
    private func openGallery(){
        var config = PHPickerConfiguration()
        config.selectionLimit = 6 - selectedMedia.count
        if #available(iOS 15.0, *) {
            config.selection = .ordered
        } else {
            // Fallback on earlier versions
        }
        let PHPickerVC = PHPickerViewController(configuration: config)
        PHPickerVC.delegate = self
        present(PHPickerVC, animated: true)
        
    }
    private func openVideoGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.videoMaximumDuration = 30
        present(picker, animated: true, completion: nil)
    }
    
    private func openCamera( isRecordVideo:Bool) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        if isRecordVideo {
            picker.mediaTypes = [kUTTypeMovie as String]
        }else{
            // capture picture
            picker.mediaTypes = [kUTTypeImage as String]
        }
       
        present(picker, animated: true, completion: nil)
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
                    let urlAsset = AVURLAsset(url: inputURL, options: nil)
                    guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
                        handler(nil)
                        return
                    }

                    exportSession.outputURL = outputURL
        print(outputURL)
        exportSession.outputFileType = AVFileType.mp4
        //AVFileTypeQuickTimeMovie (m4v)
                    exportSession.shouldOptimizeForNetworkUse = true
                    exportSession.exportAsynchronously { () -> Void in
                        handler(exportSession)
                    }
        
                }
    
}

