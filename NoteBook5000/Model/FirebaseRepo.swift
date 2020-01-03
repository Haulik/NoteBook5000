//
//  FirebaseRepo.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 02/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import Firebase
import FirebaseFirestore

class FirebaseRepo {
    
    //Database Firestore
    let userCollection = Firestore.firestore().collection("user")

    

    //SignUp
    func registrer(usr:String, pwd:String, usrname:String, caller: UIViewController) {
        
        Auth.auth().createUser(withEmail: usr, password: pwd) { (result, error) in
            if let error = error {
                print("Failed to sign up with error: ", error.localizedDescription)
                self.createAlert(title: "Error", message: error.localizedDescription, caller: caller)
                return
            }
                        
            guard let uid = result?.user.uid else { return }
                        
            let values = ["email": usr, "username": usrname, "role": "Normal"]
                        
            self.setDatabase(uid: uid, values: values, caller: caller)
   
        }
                                             
    }

    // Sender data op til databasen
    func setDatabase(uid:String, values:[String:Any], caller:UIViewController){
        
        self.userCollection.document(uid).setData(values) { error in
        if let error = error {
            print("Failed to updata database values with error: ", error.localizedDescription)
            self.createAlert(title: "Error", message: error.localizedDescription, caller: caller)
            return
        }
        print("succesfully signed user up..")
            self.loadUserData()
            caller.dismiss(animated: true, completion: nil)
      
        
     }
    }
    
    
    func loadUserData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("user").document(uid).getDocument {(document, error) in
            if let document = document, document.exists {
                let username = document.get("username") as! String
                //self.welcomeLabel.text = "Welcome \(username)"
                //self.userName = username
                print(username)
            }else{
                print("Say what? \(error.debugDescription)")
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    //Loader Username fra database (virker ikke)
    /*
    func loadData(uid:String, caller:UIViewController) {
        Firestore.firestore().collection("user").document(uid).getDocument {(document, error) in
            if let document = document, document.exists {
                let username = document.get("username") as! String
                let ef=HomeController()
                ef.setUserData(username: username)
            }
        }
    }
    */
    
    
    //laver en popup, med en "ok" knap
    func createAlert (title:String, message:String, caller: UIViewController, afterConfirm: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            //Action
            print("OK")
        }))
        
        caller.present(alert, animated: true, completion: nil)

    }
    

}
