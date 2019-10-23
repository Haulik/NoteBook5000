//
//  LoginController.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 21/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit


class LoginController: UIViewController, GIDSignInUIDelegate, LoginButtonDelegate {
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = AccessToken.current {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self as GIDSignInDelegate
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let usr = loginEmail.text, let pwd = loginPassword.text {
            Auth.auth().signIn(withEmail: usr, password: pwd) { (result, error) in
                if error == nil {
                    print("user logged in")
                    
                    guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                    guard let controller = navController.viewControllers[0] as? HomeController else { return }
                    
                    controller.loadUserData()
                        
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print("some error during \(error.debugDescription)")
                }
            }
        }
    }
    @IBAction func GoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @IBAction func FacebookSignIn(_ sender: Any) {
        firebaseFaceBookLogin(accessToken: accessToken.authentication)
    }
    
    func firebaseFaceBookLogin(accessToken: String){
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential, completion: {(result, error) in
            if let error = error {
                print("Failed to sign in with error:", error.localizedDescription)
                return
            }
            // User has signed
            print("Firebase Login Done:")
            if let user = Auth.auth().currentUser {
                print("Current firebase user is:", user)
            }
            
    })
    
 }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("User logged in")
        
        switch result {
        case .failed(let err):
            print(err)
        case .cancelled:
            print("cancelled")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("success")
            print(accessToken)
            firebaseFaceBookLogin(accessToken: accessToken.authenticationToken)
        }
    }
}

extension LoginController: GIDSignInDelegate {
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
            
            let values = ["email": email, "username": username]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                guard let controller = navController.viewControllers[0] as? HomeController else { return }
                
                controller.loadUserData()
                
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
