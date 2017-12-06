//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Admin on 27.08.17.
//  Copyright © 2017 NS. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var tagButton: UIButton!
//    @IBOutlet weak var getButton: UIButton!
    
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    lazy var geocoder: CLGeocoder = {
    let geocoder: CLGeocoder = CLGeocoder()
    return geocoder
    }()
    
    @IBAction func getLocation() {
        // ask for user permission
        
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // if user denied for the first time it will show the message to activate in settings. This shows the alert if the authorization status is denied or restricted
        if authStatus == .denied || authStatus == .restricted {
            
            return
        }
        
        locationManager.startUpdatingLocation()
        self.startLocation = nil
       
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation : CLLocation = locations[locations.count - 1]
        self.latitudeLabel.text = String(format: "%.4f", latestLocation.coordinate.latitude)
        self.longitudeLabel.text = String(format: "%.4f", latestLocation.coordinate.longitude)
        startLocation = latestLocation
        self.geocoder.reverseGeocodeLocation(latestLocation) { (placemarkes, error) in
            
            if let firstPlaceMark = placemarkes?.first{
                if let placeName = firstPlaceMark.name{
                    self.addressLabel.text = placeName
                }
                
            }
//            if(error != nil || (placemarkes?.count == 0)){
//                self.addressLabel.text = "can not find a place !"
//            }else{
//                if let firstPlaceMark = placemarkes!.first{
//                    self.addressLabel.text = firstPlaceMark!.name
//                }
//
//            }
        }
//        self.horizontalAccuracyLabel.text = String(format: "%.4f", latestLocation.horizontalAccuracy)
//        self.altitudeLabel.text = String(format: "%.4f", latestLocation.altitude)
//        self.verticalAccuracyLabel.text = String(format: "%.4f", latestLocation.verticalAccuracy)
        
//        if startLocation == nil {
//            startLocation = latestLocation
//        }
//
//        let distanceBetween: CLLocationDistance =
//            latestLocation.distance(from: startLocation)
        
//        self.distanceLabel.text = String(format: "%.2f", distanceBetween)
    }


   

    func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
//        updatingLocation = false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func touchesBegan(_ _touches: Set<UITouch>, with event: UIEvent?){
        descTV.resignFirstResponder()
        titleTF.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "New Event"
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// if the app is currently updating the location then the button’s title becomes Stop, otherwise it is Get My Location. Should be called anywhere where was called updateLabels()
    func configureGetButton() {
        
    }
    
    
    
        
    // rewrited method
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        line1.add(text: placemark.subThoroughfare)
        line1.add(text: placemark.thoroughfare)
        var line2 = ""
        line2.add(text: placemark.locality)
        line2.add(text: placemark.administrativeArea)
        line2.add(text: placemark.postalCode)
        line1.add(text: line2, separatedBy: "\n")
        return line1
    }
    
    @IBAction func onPostEvent(_ sender: UIButton) {
        if titleTF.text?.count == 0{
            return
        }
        let reference = Database.database().reference().child("positions")
        let childReference = reference.childByAutoId()
        
        
        let timestamp = NSDate().timeIntervalSince1970 as NSNumber
        
        
        let values = ["title": titleTF.text!,"description":self.descTV.text ?? " ","timestamp":timestamp,"la":startLocation.coordinate.latitude,"lo":startLocation.coordinate.longitude,"adress":self.addressLabel.text!] as [String : Any]
        
        //        childReference.updateChildValues(values)
        
        childReference.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
 
    
   

    
    
}

