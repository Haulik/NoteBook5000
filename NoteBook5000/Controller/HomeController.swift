//
//  ViewController.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 20/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import FirebaseUI
import FirebaseAuth
import UIKit
import GoogleSignIn

class HomeController: UIViewController {
    @IBOutlet weak var WelcomeLabel: UILabel!
    var Username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
        
    }
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
            guard let username = snapshot.value as? String else { return }
            self.WelcomeLabel.text = "Welcome \(username)"
            self.Username = username
        }
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goLogin", sender: self)
            }
        } else {
            loadUserData()
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        let title2 = "Sign out?"
        let message2 = "Are you sure you wanna sign out \(self.Username)?"
        let alert = UIAlertController(title: title2, message: message2, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "goLogin", sender: self)
                print("User: \(self.Username) logged off")
            } catch let error {
                print("Failed to sign out with error..", error)
            }        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            print("Sign out cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlert (title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "goLogin", sender: self)
            } catch let error {
                print("Failed to sign out with error..", error)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            print("NO")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

