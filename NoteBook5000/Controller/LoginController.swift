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

    //Email (Firebase login)
    @IBAction func loginPressed(_ sender: Any) {
        if let usr = loginEmail.text, let pwd = loginPassword.text {
            lg.emailLogin(usr: usr, pwd: pwd, caller: self)
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

