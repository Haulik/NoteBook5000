//
//  SignUpController.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 21/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUpController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var createEmail: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    @IBOutlet weak var createPasswordAgain: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let usr = createEmail.text, let pwd = createPassword.text, let usrname = userName.text {
            if createPassword.text == createPasswordAgain.text{
                Auth.auth().createUser(withEmail: usr, password: pwd) { (result, error) in
                    
                    if let error = error {
                        print("Failed to sign up with error: ", error.localizedDescription)
                        self.createAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": usr, "username": usrname]
                    
                    Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                        
                        if let error = error {
                            print("Failed to updata database values with error: ", error.localizedDescription)
                            self.createAlert(title: "Error", message: error.localizedDescription)
                            return
                        }
                        
                        print("succesfully signed user up..")
                        self.dismiss(animated: true, completion: nil)
                    })
                        
        }
            }else{
                createAlert(title: "Error", message: "Password did not match!")
        }
    }
}
    
    func createAlert (title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            //Action
            print("OK")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
