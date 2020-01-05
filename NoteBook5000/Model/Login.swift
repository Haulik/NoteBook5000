//
//  Login.swift
//  NoteBook5000
//
//  Created by Grp5000 on 03/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class Login {
    
    var userName = ""
    
    //logger ud med en ja nej pop op
    func signOut(caller:UIViewController, navController:UINavigationController){
        
        guard let controller = navController.viewControllers[0] as? HomeController else {return}
        
        let title2 = "Sign out?"
        let message2 = "Are you sure you wanna sign out \(controller.userName)?"
        let alert = UIAlertController(title: title2, message: message2, preferredStyle: UIAlertController.Style.alert)
        
          //Laver en alert, med YES/NO Knapper. (logger ud)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                controller.welcomeLabel.text = "Log off"
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
    
    //Email login
    func emailLogin(usr:String, pwd:String, caller:UIViewController){
        
        Auth.auth().signIn(withEmail: usr, password: pwd) { (result, error) in
            if error == nil {
                print("user logged in")
                caller.dismiss(animated: true, completion: nil)
            }else {
                fb.createAlert(title: "Failed to login", message: error!.localizedDescription, caller: caller)
                print("some error during \(error.debugDescription)")
            }
        }
    }

    //Facebook login
    func fbLogin(caller:UIViewController){
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions:["email"], from: caller) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                // Alert hvis forbindelse til facebook api ikke kan lade sig gøre
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                // Alert action
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                caller.present(alertController, animated: true, completion: nil)
            
                return
            }
            
            //Gør klar til at sende data
            guard let uid = user?.user.uid else { return }
            guard let email = user?.user.email else { return }
            guard let username = user?.user.displayName else { return }

            let values = ["email": email, "username": username]

            fb.setDatabase(uid: uid, values: values, caller: caller)

            }
        )}
    }

    
    func authenticateUserAndConfigureView(caller:UIViewController, navController:UINavigationController) {
        
        let userEmail = Auth.auth().currentUser?.email
        
        if Auth.auth().currentUser == nil
        {
            caller.performSegue(withIdentifier: "goLogin", sender: self)
        }
                   
        else if userEmail?.lowercased().contains("admin") == true
        {
            
            guard let controller = navController.viewControllers[0] as? HomeController else {return}
            
            controller.adminTest.isHidden = false
                
            if userEmail?.lowercased().contains("netto") == true {
                butikAdmin = "Netto"
            }
            
            if userEmail?.lowercased().contains("kvickly") == true {
                butikAdmin = "Kvickly"
            }
            
            if userEmail?.lowercased().contains("føtex") == true {
                butikAdmin = "Føtex"
            }

        }
            fb.loadUserData()
    }

}

extension LoginController: GIDSignInDelegate {

    //GOOGLE
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to sign in with error:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            if let error = error {
                print("Failed to sign in and retrieve data with error:", error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else { return }
            guard let username = result?.user.displayName else { return }
            
            let values = ["email": email, "username": username, "role":"Normal"]
            
            fb.setDatabase(uid: uid, values: values, caller: self)
        }
    }
}
