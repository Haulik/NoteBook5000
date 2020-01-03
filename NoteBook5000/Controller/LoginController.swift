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

class LoginController: UIViewController, GIDSignInUIDelegate{
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    let userCollection = Firestore.firestore().collection("user")
    var lg = Login()
    var fb = FirebaseRepo()
 
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self as GIDSignInDelegate
    }

    //Email
    @IBAction func loginPressed(_ sender: Any) {
        
        if let usr = loginEmail.text, let pwd = loginPassword.text {
            Auth.auth().signIn(withEmail: usr, password: pwd) { (result, error) in
                if error == nil {
                    print("user logged in")
                    
                    guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                    guard let controller = navController.viewControllers[0] as? HomeController else { return }
                    
                    self.fb.loadUserData()
                        
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print("some error during \(error.debugDescription)")
                }
            }
        }
        
        
    }
    //Google
    @IBAction func GoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    //Facebook
    @IBAction func FacebookSignIn(_ sender: Any) {
        lg.fbLogin(caller: self)
  
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
            
            let values = ["email": email, "username": username]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                guard let controller = navController.viewControllers[0] as? HomeController else { return }
                
                self.fb.loadUserData()
                
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
