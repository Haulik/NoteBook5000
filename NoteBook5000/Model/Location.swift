//
//  Location.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 03/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import CoreLocation
import UIKit

class Location {
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    
    func testing(caller:CLLocationManagerDelegate){
        StopMonitor()
        //authenticateUserAndConfigureView()
        
        // Do any additional setup after loading the view, typically from a nib.
                
        locationManager.delegate = caller
                    
        locationManager.requestAlwaysAuthorization()
                        
        locationManager.startUpdatingLocation()
                    
        locationManager.distanceFilter = 100
                    
                
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(55, 13), radius: 1000, identifier: "Netto")
                
        locationManager.startMonitoring(for: geoFenceRegion)
        
        postLocalNotifications(eventTitle: "HEJ")
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation], caller:UIViewController) {
            
            for currentLocation in locations{
                print("TestingHERE: \(index): \(currentLocation)")
                // "0: [locations]"
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, caller:UIViewController) {
        print("somthing went wrong: \(error)")
    }
    
    
    func StopMonitor(){
        let monitoredRegions = locationManager.monitoredRegions
        
        for region in monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }
    }
        
        
        
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion, caller:UIViewController) {
        print("Entered: \(region.identifier)")
        //postLocalNotifications(eventTitle: "fesifbes")
        postLocalNotifications(eventTitle: "Entered: \(region.identifier)")
        //fea.view.backgroundColor = UIColor.green
        }
        
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion, caller:UIViewController) {
            print("Exited: \(region.identifier)")
        postLocalNotifications(eventTitle: "Exited: \(region.identifier)")
        //fea.view.backgroundColor = UIColor.red
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

    
    
    
}
