//
//  Location.swift
//  NoteBook5000
//
//  Created by Grp5000 on 03/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import CoreLocation
import UIKit

class Location {
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    func stopMonitor(){
        let monitoredRegions = locationManager.monitoredRegions
        
        for region in monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }
    }

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
    
    func setRegion(caller: CLLocationManagerDelegate){
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(44, 13), radius: 1000, identifier: "Netto")
        let geoFenceRegion2:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(55, 13), radius: 1000, identifier: "Føtex")
        let geoFenceRegion3:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(66, 13), radius: 1000, identifier: "Kvickly")
        
        locationManager.delegate = caller
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
            
        locationManager.startMonitoring(for: geoFenceRegion)
        locationManager.startMonitoring(for: geoFenceRegion2)
        locationManager.startMonitoring(for: geoFenceRegion3)
    }
    
    
}

extension HomeController: CLLocationManagerDelegate {
    
    //Did update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
        for currentLocation in locations{
            print("TestingHERE: \(index): \(currentLocation)")

        }
    }
    
    //error handler
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("somthing went wrong: \(error)")
        print(error.localizedDescription)
    }
    
    //Enter region (Føtex, kvickly, Netto)
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
        lc.postLocalNotifications(eventTitle: "Entered: \(region.identifier)")
        
    }
    
    //Exited region (Føtex, kvickly, Netto)
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
        lc.postLocalNotifications(eventTitle: "Exited: \(region.identifier)")

    }
    

}
