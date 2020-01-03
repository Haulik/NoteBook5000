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

class HomeController: UIViewController, UNUserNotificationCenterDelegate  {
    @IBOutlet weak var welcomeLabel: UILabel!
    var userName = ""
    let userCollection = Firestore.firestore().collection("user")
    let locationManager:CLLocationManager = CLLocationManager()
    var lg = Login()
    var lc = Location()
    var fb = FirebaseRepo()
    let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(55, 13), radius: 1000, identifier: "Netto")
    let geoFenceRegion2:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(23, 13), radius: 1000, identifier: "Føtex")
    let geoFenceRegion3:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(66, 13), radius: 1000, identifier: "Kvickly")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lg.authenticateUserAndConfigureView(caller: self)
        
        //lc.testing(caller: self)
        
        lc.StopMonitor()
        //authenticateUserAndConfigureView()
        
        // Do any additional setup after loading the view, typically from a nib.
                
        locationManager.delegate = self
                    
        locationManager.requestAlwaysAuthorization()
                        
        locationManager.startUpdatingLocation()
                    
        locationManager.distanceFilter = 100
                    
            
        locationManager.startMonitoring(for: geoFenceRegion)
        locationManager.startMonitoring(for: geoFenceRegion2)
        locationManager.startMonitoring(for: geoFenceRegion3)

    }
    
    //Kig i FirebaseRepo
    
    /*
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("user").document(uid).getDocument {(document, error) in
            if let document = document, document.exists {
                let username = document.get("username") as! String
                self.welcomeLabel.text = "Welcome \(username)"
                self.userName = username
            }else{
                print("Say what? \(error.debugDescription)")
            }
            
        }
    }
 */
    
    //Virker ikke
    func setUserData(username:String){
        self.welcomeLabel.text = "Welcome \(username)"
        self.userName = username
    }
            
    //Checker om der er en logget ind
    
    
    /*
    func authenticateUserAndConfigureView() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goLogin", sender: self)
            }
        }
        else if Auth.auth().currentUser?.email == "Admin"  {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GoAdmin", sender: self)
            }
            
        }else{
            fb.loadUserData()
        }
    }
    */
    
    
    //Logger ud
    @IBAction func signOut(_ sender: Any) {
        
        lg.signOut(caller: self)
        
        /*
        let title2 = "Sign out?"
        let message2 = "Are you sure you wanna sign out \(self.userName)?"
        let alert = UIAlertController(title: title2, message: message2, preferredStyle: UIAlertController.Style.alert)
      
        
        //Laver en alert, med YES/NO Knapper. (logger ud)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                self.welcomeLabel.text = "Logget ud"
                self.performSegue(withIdentifier: "goLogin", sender: self)
                print("User: \(self.userName) logged off")
            } catch let error {
                print("Failed to sign out with error..", error)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            print("Sign out cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
 */
    }
    
    
    //Netto knap
    @IBAction func NettoButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Netto", sender: self)
    }
    //Kvivkly Knap
    @IBAction func KvicklyButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Netto", sender: self)
    }
    //Føtex Knap
    @IBAction func FøtexButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Netto", sender: self)
    }
    
    //Laver Notification
    func postLocalNotifications(eventTitle:String){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "You've entered a new region"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
                print("Here")
            }
            else{
                print("added")
            }
        })
    }
    
    
}

