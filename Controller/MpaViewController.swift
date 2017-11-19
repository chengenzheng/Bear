//
//  FirstViewController.swift
//  Bear
//
//  Created by chengen Zheng on 2017/10/17.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
import MapKit
import Firebase
class MpaViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var messageNodeRef : DatabaseReference!
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(Location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(Location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let initialLocation = CLLocation(latitude: 43.038611, longitude: -87.928759)
        centerMapOnLocation(Location: initialLocation)
        messageNodeRef = Database.database().reference().child("messages")
        
        let pinMessageID = "msg-1"
        var pinMessage: Message?
        messageNodeRef.child(pinMessageID).observe(.value, with: { (snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: Any]
            {
                if pinMessage != nil
                {
                    self.mapView.removeAnnotation(pinMessage!)
                }
                let pinLat = dictionary["latitude"] as! Double
                let pinLong = dictionary["longitude"] as! Double
                let messageDisabled = dictionary["isDisabled"] as! Bool
                let message = Message(title: (dictionary["title"] as? String)!, locationName: (dictionary["locationName"] as? String)!, username: (dictionary["username"] as? String)!, coordinate: CLLocationCoordinate2D(latitude: pinLat, longitude: pinLong), isDisabled: messageDisabled)
                pinMessage = message
                if !message.isDisabled {
                    self.mapView.addAnnotation(message)
                }
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
}
