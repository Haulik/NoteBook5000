//
//  FirebaseRepo.swift
//  NoteBook5000
//
//  Created by Grp5000 on 02/01/2020.
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
                        
            self.setDatabase(uid: uid, values: values, caller: caller, emailRegistrer: true)
   
        }
                                             
    }

    // Sender data op til databasen
    func setDatabase(uid:String, values:[String:Any], caller:UIViewController, emailRegistrer: Bool? = false){
        
        self.userCollection.document(uid).setData(values) { error in
        if let error = error {
            print("Failed to updata database values with error: ", error.localizedDescription)
            self.createAlert(title: "Error", message: error.localizedDescription, caller: caller)
            return
        }
        print("succesfully signed user up..")
        //self.loadUserData()
        if emailRegistrer == false {
            caller.dismiss(animated: true, completion: nil)
        }else{
            caller.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    
     }
    }
    
    
    func loadUserData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("user").document(uid).getDocument {(document, error) in
            if let document = document, document.exists {
                let username = document.get("username") as! String
                
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                guard let controller = navController.viewControllers[0] as? HomeController else { return }
                
                controller.welcomeLabel.text = "Welcome \(username)"
                //self.welcomeLabel.text = "Welcome \(username)"
                controller.userName = username
                print(username)
                
            }else{
                print("Say what? \(error.debugDescription)")
            }
            
        }
        
    }
    
    func documentListener(navController:UINavigationController) {
        print("documentListener called")
        guard let controller = navController.viewControllers[1] as? TableViewController else {return}
        Firestore.firestore().collection(butikSender).addSnapshotListener({ (snapshot, error) in
            print("received snapshot")
            controller.data.removeAll()
            for document in snapshot!.documents {

                if let tekst = document.data()["tekst"] as? String,
                let imageName = document.data()["image"] as? String,
                    let title = document.data()["title"] as? String{
                    self.downloadImage(filename: imageName, note: tekst, title: title, navController: navController)
                }
            }
            
        })
        
    }
    
    func downloadImage(filename:String, note:String, title:String, navController:UINavigationController)  {
        // Create a reference with an initial file path and name
        let pathReference = Storage.storage().reference(withPath: filename)
        guard let controller = navController.viewControllers[1] as? TableViewController else {return}
        var image:UIImage?
        
        pathReference.getData(maxSize: 4000*4000) { (data, error) in
            if error != nil {
                print("error downloading file \(error.debugDescription)")
            }else{
                image = UIImage(data: data!)
                controller.data.append(CellData.init(title: title, message: note, image: image, imageTekst: "Test"))
                print("success in downloading image \(image?.size)")
                
            }
            controller.tableView.reloadData()
        }
    }
    
    
    
    func uploadPhoto(messageBody:String, title:String, image:UIImage, caller:UIViewController){
       // guard let messageBody = self.textField.text else {return}
       // guard let title = self.titleField.text else {return}
        let randomID = UUID.init().uuidString
        let imagePath = "Picture/\(butikAdmin)/\(randomID).jpg"
        let uploadRef = Storage.storage().reference(withPath: imagePath)
        
        guard let imageData =  image.jpegData(compressionQuality: 1) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Oh no, something went wrong! \(error.localizedDescription)")
                return
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
            
            self.uploadTekst(imagePath: imagePath, messageBody: messageBody, title: title, caller: caller)
            
        }
    }
    
    
    func uploadTekst(imagePath:String, messageBody:String, title:String, caller:UIViewController){
        
            Firestore.firestore().collection(butikAdmin).addDocument(data: ["tekst": messageBody, "image": imagePath, "title": title ]) { (error) in
                if let error = error{
                    print("There was an error saving data to Firestore, \(error.localizedDescription)")
                } else {
                    print("Saved data")
                    self.createAlert(title: "Succes", message: "You have had succesful uploaded", caller: caller)
                }
            }
    }
    
    
    
    
    
    
    
    
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
