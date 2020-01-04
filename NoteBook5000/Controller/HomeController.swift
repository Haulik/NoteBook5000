//
//  ViewController.swift
//  NoteBook5000
//
//  Created by Grp5000 on 20/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import FirebaseUI
import FirebaseAuth
import Firebase
import UIKit
import GoogleSignIn
import CoreLocation
import UserNotifications


var butikSender = ""
var butikAdmin = ""

class HomeController: UIViewController, UNUserNotificationCenterDelegate  {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var adminTest: UIButton!
    
    
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
        //lg.authenticateUserAndConfigureView(caller: self, navController: navController)
        lc.StopMonitor()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
            
        locationManager.startMonitoring(for: geoFenceRegion)
        locationManager.startMonitoring(for: geoFenceRegion2)
        locationManager.startMonitoring(for: geoFenceRegion3)

    }
        
    @IBAction func adminButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goAdmin", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navController = navigationController else {return}
        adminTest.isHidden = true
        lg.authenticateUserAndConfigureView(caller: self, navController: navController)
    }
    

    //Logger ud
    @IBAction func signOut(_ sender: Any) {
        guard let navController = navigationController else {return}
        lg.signOut(caller: self, navController: navController)
    }
    
    //Netto knap
    @IBAction func NettoButton(_ sender: UIButton) {
        butikSender = "Netto"
        segueTableView()
    }
    //Kvivkly Knap
    @IBAction func KvicklyButton(_ sender: UIButton) {
        butikSender = "Kvickly"
        segueTableView()
    }
    //Føtex Knap
    @IBAction func FøtexButton(_ sender: UIButton) {
        butikSender = "Føtex"
        segueTableView()
    }
    
    func segueTableView(){
        self.performSegue(withIdentifier: "tableView", sender: self)
    }

}

