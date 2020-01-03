//
//  SignUpController.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 21/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var createEmail: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    @IBOutlet weak var createPasswordAgain: UITextField!
    
    var fb = FirebaseRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Register user
    @IBAction func registerPressed(_ sender: UIButton) {
        if let usr = createEmail.text, let pwd = createPassword.text, let usrname = userName.text {
            if createPassword.text == createPasswordAgain.text{
                fb.registrer(usr: usr, pwd: pwd, usrname: usrname, caller: self)
                
            }else{
                fb.createAlert(title: "Error", message: "Password did not match!", caller: self)
            }
        }
    }
}
