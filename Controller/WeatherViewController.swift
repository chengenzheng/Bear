//
//  WeatherViewController.swift
//  Bear
//
//  Created by chengen Zheng on 2017/10/14.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
import Firebase

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var lblWelcome: UILabel!
    
    @IBOutlet weak var lblWeather: UILabel!
    
    @IBOutlet weak var btnSunny: UIButton!
   
    @IBOutlet weak var btnFroggy: UIButton!
    
    let weatherNodeRef = Database.database().reference().child("weatherCondition")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherNodeRef.observe(.value) { (snapshot: DataSnapshot) in
            self.lblWeather.text = (snapshot.value as AnyObject).debugDescription
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnFroggy_touchUpInside(_ sender: UIButton) {
    
        weatherNodeRef.setValue("Froggy")
    }
    
    @IBAction func btnSunny_touchUpInside(_ sender: UIButton) {
    
        weatherNodeRef.setValue("Sunny")
    }
    
    
    
}

