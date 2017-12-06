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
        messageNodeRef = Database.database().reference().child("positions")
        
        messageNodeRef.observe(.childAdded, with: { (snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: Any]
            {
                guard let la = dictionary["la"] else{
                    return
                }
                guard let lo = dictionary["lo"] else{
                    return
                }
                
                let title = dictionary["title"] as! String
                let dest = dictionary["description"] as! String
                
                //创建一个大头针对象
                let objectAnnotation = MKPointAnnotation()
                //设置大头针的显示位置
                objectAnnotation.coordinate = CLLocation(latitude: (la as AnyObject).doubleValue,
                                                         longitude: (lo as AnyObject).doubleValue).coordinate
                //设置点击大头针之后显示的标题
                objectAnnotation.title = title
                //设置点击大头针之后显示的描述
                objectAnnotation.subtitle = dest
                //添加大头针
                self.mapView.addAnnotation(objectAnnotation)
                
                
            }
            
        })
    }
    
    @IBAction func onAddEventClick(_ sender: UIBarButtonItem) {
        
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
