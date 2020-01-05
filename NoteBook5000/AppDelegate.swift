//
//  AppDelegate.swift
//  NoteBook5000
//
//  Created by Grp5000 on 20/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Sætter vi Firebase op
        FirebaseApp.configure()
        
        //Google setup
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Objekt der håndtere vores notifikationer
        let center = UNUserNotificationCenter.current()
        
        let Options: UNAuthorizationOptions = [.sound, .alert]
        
        // Metode som bliver kaldt fra vores UNUSerNotificationCenterDelegate
        center.requestAuthorization(options: Options) { (granted, error) in
            if error != nil {
                print(error)
            }
        }
        
        center.delegate = self
        return true
    }
    
    // Fortæller appen hvordan vores notifikationer bliver præsenteret
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handle = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        return handle
    }

    
    
}

