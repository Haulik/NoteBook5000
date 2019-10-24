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
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FBSDKShareKit



class LoginController: UIViewController, GIDSignInUIDelegate, LoginButtonDelegate{
    
    
    
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
  //  private let readPermissions: [Permission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
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
       
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
        
        
        
        
      /*  if let accessToken = AccessToken.current {
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential, completion: {(result, error) in
                if let error = error {
                    print("Failed to sign in with error:", error.localizedDescription)
                    return
                }
                // User has signed
                print("Firebase Login Done:")
                if let user = Auth.auth().currentUser {
                    print("Current firebase user is:", user)
                }*/
                
        })
            }
    }
    
    func firebaseFaceBookLogin(accessToken: String){
        if let accessToken = AccessToken.current {
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
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
 }
    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_): break
        default: break
        }
    }
    
    fileprivate func didLoginWithFacebook() {
    // Successful log in with Facebook
    if let accessToken = AccessToken.current {
        // If Firebase enabled, we log the user into Firebase
       // var message: String = ""
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("There was an error.", error.localizedDescription)
                    return
                }
                print("User was sucessfully logged in.")
            }
            
            

            
          //  let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
         //   alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         //   self.display(alertController: alertController)
        }
    }
    
    func login(credential: AuthCredential, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
            print(firebaseUser!)
            completionBlock(error == nil)
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logged out")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error?.localizedDescription as Any)
            return
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
