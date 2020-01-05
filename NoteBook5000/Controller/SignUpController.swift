//
//  SignUpController.swift
//  NoteBook5000
//
//  Created by Grp5000 on 21/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var createEmail: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    @IBOutlet weak var createPasswordAgain: UITextField!
    
    //Register user
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = createEmail.text, let pwd = createPassword.text, let usrname = userName.text {
            if createPassword.text != createPasswordAgain.text{
                fb.createAlert(title: "Error", message: "Password did not match!", caller: self)
                return
            }
            if email.lowercased().contains("admin") == true || usrname.lowercased().contains("admin") == true {
                fb.createAlert(title: "Error", message: "Email kan ikke indeholde 'admin'", caller: self)
                return
            }
            fb.registrer(email: email, pwd: pwd, usrname: usrname, caller: self)
        }
    }
}
