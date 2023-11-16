//
//  infoC.swift
//  tlbiy
//
//  Created by khaled on 6/11/19.
//  Copyright © 2019 mrhbaa. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import MOLH

class SendLocC: ViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var hdr: UIView!
    @IBOutlet weak var pin: UIImageView!
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var img: UIImageView!

    var lat:Double = 0
    var lng:Double = 0
    var loc:String = ""
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var loc_src: UILabel!
    @IBOutlet weak var loc_src_sub: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loc_src.setLineSpacing()
        loc_src_sub.setLineSpacing()

        map.delegate = self
        map.isMyLocationEnabled = true
        setMapStyle()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        if(Constants.tempPlace_id != ""){
            let placesClient = GMSPlacesClient()
            placesClient.lookUpPlaceID(Constants.tempPlace_id, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place details ")
                    return
                }
                self.move(to: place.coordinate,15)
                self.getLoc(place.coordinate)
            })
        }
    }
    //================================  delegate  =================================
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        getNewLocation()
    }
    
    func getNewLocation(){
        let coordinate = map.projection.coordinate(for: map.center)
        getLoc(coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let coor = location?.coordinate {
            
            Constants.lat = coor.latitude
            Constants.lng = coor.longitude
            print(coor.latitude)
            move(to: CLLocationCoordinate2D(latitude: Constants.lat, longitude: Constants.lng), 17)
            getLoc(coor)
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(){
        if lat != 0 {
            Constants.orderLoc_represnted = true
            Constants.orderLat = lat
            Constants.orderLng = lng
            //order.loc = loc_src.text!
            //order.sub_loc = loc_src_sub.text!
            let marker = addPin(Constants.orderLat, Constants.orderLng,"mark_loc")
            delay(0.3) {
                self.take_screen_shot()
                self.navigationController?.popViewController(animated: true)
            }
        }else{
//            msg("حدد الموقع من فضلك")
            StaticFunctions.createErrorAlert(msg: "Specify the location, please".localize)
        }
    }
    
    func take_screen_shot(){
        let image = UIGraphicsImageRenderer(size: map.bounds.size).image { _ in
            map.drawHierarchy(in: map.bounds, afterScreenUpdates: true)
        }
        saveToDocuments(image: image, filename: "image.jpg")
    }
    
    func saveToDocuments(image:UIImage,filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = image.jpegData(compressionQuality: 0.1) {
            do {
                try data.write(to: fileURL)
                Constants.orderFilePath = fileURL
               // self.uploadFile(fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
    
    func uploadFile(_ filePath:URL){
     //   BG.load(self)
      //  guard let url = URL(string: user.newBaseUrl+"send_message") else {return}
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(filePath, withName: "images[]")
        },
                  to: "\(Constants.DOMAIN)upload.php").responseString { (e) in
            if let res = e.value {
//                BG.hide(self)
                print(res)
                if(res.contains("fail")){
//                    self.msg("مشكلة في تحميل الملف")
                    StaticFunctions.createErrorAlert(msg: "مشكلة في تحميل الملف")
                }else{
                    Constants.loc_img = res
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    func addPin(_ lat:Double,_ lng:Double, _ img:String) -> GMSMarker {
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
        marker.icon = UIImage(named: img)?.af.imageAspectScaled(toFit: CGSize(width: 60, height: 60))
        marker.tracksViewChanges = true
        marker.appearAnimation = .pop
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = map
        return marker
    }
    
    
    
    //================================  functions  ================================
    func setMapStyle(){
        do {
            if let styleURL = Bundle.main.url(forResource: "style_json", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    
    func zoom(_ marker:GMSMarker, _ zoom:Float){
        let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: zoom)
        self.map?.animate(to: camera)
    }
    
    
    func move(to:CLLocationCoordinate2D,_ zoom:Float=17){
        let camera = GMSCameraPosition.camera(withLatitude: to.latitude
            , longitude: to.longitude, zoom: zoom)
        self.map?.animate(to: camera)
    }
    
    
    func getLoc(_ coor:CLLocationCoordinate2D){
        //print(coor.latitude)
        lat = coor.latitude
        lng = coor.longitude
        AF.request("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coor.latitude),\(coor.longitude)&sensor=true&language=\(MOLHLanguage.currentAppleLanguage())&key=\(Constants.api_key)", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if let result = response.value {
                    let JSON = result as! NSDictionary
                    if let resArr = JSON["results"] as? NSArray {
                        if(resArr.count > 0 ){
                            if let obj0 = resArr[0] as? NSDictionary {
                                let loc = obj0["formatted_address"] as! String
                                Constants.orderLoc = loc
                                self.formatAddress(loc)
                            }
                        }
                        
                    }
                }
        }
    }
    
    
    func formatAddress(_ loc:String){
        let new_loc = loc.replacingOccurrences(of: "،Unnamed Road", with: "").replacingOccurrences(of: ",Unnamed Road", with: "").replacingOccurrences(of: "Unnamed Road", with: "شارع غير معروف")
        
        self.loc = new_loc
        
        self.loc_src.text = ""
        self.loc_src_sub.text = ""
        
        if new_loc.contains(","){
            let n = new_loc.components(separatedBy: ",")
            self.loc_src.text = n[0]
            for i in 1...n.count-1 {
                self.loc_src_sub.text?.append("\(n[i]) - ")
            }
            self.loc_src_sub.text = String((self.loc_src_sub.text?.dropLast(2))!)
        }else if new_loc.contains("،"){
            let n = new_loc.components(separatedBy: "،")
            self.loc_src.text = n[0]
            for i in 1...n.count-1 {
                self.loc_src_sub.text?.append("\(n[i]) - ")
            }
            self.loc_src_sub.text = String((self.loc_src_sub.text?.dropLast(2))!)
            
        }else{
            self.loc_src.text = new_loc
            self.loc_src_sub.text = ""
        }
    }
    
    @IBAction func go(_ sender: Any) {
      //  goNav("placesv")
        print("Gooooo")
    }
    
   
    
}
