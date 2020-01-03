//
//  Login.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 03/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class Login {
    
    var fb = FirebaseRepo()
    var userName = ""
    
    
    //Email login (Not done)
    func emailLogin(usr:String, pwd:String, caller:UIViewController) {
        Auth.auth().signIn(withEmail: usr, password: pwd) { (result, error) in
            if error == nil {
                print("user logged in")
                
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                guard let controller = navController.viewControllers[0] as? HomeController else { return }
                
                //controller.loadUserData()
                    
                caller.dismiss(animated: true, completion: nil)
            }else {
                print("some error during \(error.debugDescription)")
            }
        }
    
    }
    
    
    
    //logger ud med en ja nej pop op
    func signOut(caller:UIViewController){
        let title2 = "Sign out?"
        let message2 = "Are you sure you wanna sign out \(self.userName)?"
        let alert = UIAlertController(title: title2, message: message2, preferredStyle: UIAlertController.Style.alert)
        
          
          //Laver en alert, med YES/NO Knapper. (logger ud)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                //caller.welcomeLabel.text = "Logget ud"
                //let home = HomeController()
               // home.welcomeLabel.text = "Logget ud"
                caller.performSegue(withIdentifier: "goLogin", sender: self)
                print("User: \(self.userName) logged off")
              } catch let error {
                  print("Failed to sign out with error..", error)
              }
              
          }))
          
          alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
              print("Sign out cancel")
          }))
          
          caller.present(alert, animated: true, completion: nil)
    }
    

    
    func authenticateUserAndConfigureView(caller:UIViewController) {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                caller.performSegue(withIdentifier: "goLogin", sender: self)
            }
        }
        else if Auth.auth().currentUser?.email == "Admin"  {
            DispatchQueue.main.async {
                caller.performSegue(withIdentifier: "GoAdmin", sender: self)
            }
            
        }else{
            fb.loadUserData()
        }
    }
    
    
}
