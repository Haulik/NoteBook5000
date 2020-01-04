//
//  ViewController.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 20/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import FirebaseUI
import FirebaseAuth
import Firebase
import UIKit
import GoogleSignIn
import CoreLocation
import UserNotifications


var butikSender = 0

class HomeController: UIViewController, UNUserNotificationCenterDelegate  {
    @IBOutlet weak var welcomeLabel: UILabel!
    var userName = ""
    let locationManager:CLLocationManager = CLLocationManager()
    var lg = Login()
    var lc = Location()
    var fb = FirebaseRepo()
    let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(44, 13), radius: 1000, identifier: "Netto")
    let geoFenceRegion2:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(55, 13), radius: 1000, identifier: "Føtex")
    let geoFenceRegion3:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(66, 13), radius: 1000, identifier: "Kvickly")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lg.authenticateUserAndConfigureView(caller: self)
        lc.StopMonitor()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
            
        locationManager.startMonitoring(for: geoFenceRegion)
        locationManager.startMonitoring(for: geoFenceRegion2)
        locationManager.startMonitoring(for: geoFenceRegion3)

    }
    

    //Logger ud
    @IBAction func signOut(_ sender: Any) {
        guard let navController = navigationController else {return}
        lg.signOut(caller: self, navController: navController)
    }
    
    //Netto knap
    @IBAction func NettoButton(_ sender: UIButton) {
        butikSender = 0
        self.performSegue(withIdentifier: "Netto", sender: self)
    }
    //Kvivkly Knap
    @IBAction func KvicklyButton(_ sender: UIButton) {
        butikSender = 1
        self.performSegue(withIdentifier: "Netto", sender: self)
    }
    //Føtex Knap
    @IBAction func FøtexButton(_ sender: UIButton) {
        butikSender = 2
        self.performSegue(withIdentifier: "Netto", sender: self)
    }

}

