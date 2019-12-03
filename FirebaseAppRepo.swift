//
//  FirebaseRepo2.swift
//  BestFriendApp
//
//  Created by Thomas Haulik Barchager on 01/11/2019.
//  Copyright © 2019 Jonathan Nissen. All rights reserved.
//

import Firebase
import FirebaseFirestore


class FirebaseAppRepo {

    var ref:DatabaseReference?
    var randomUserID:String?
    let friendCollection = Firestore.firestore().collection("Friend")
    var GPS:String?
    
    func uploadButtonTest() {
        if randomUserID != nil {
            friendCollection.document(randomUserID!).setData(["Location" : GPS!]) { error in
        if let error = error{
            print("Something went wrong! \(error.localizedDescription)")
            return
        }
        print("YES")
    }
        }else{
            print("NO ID User")
        }
    }
    

    func startListen(insertId:String) {

       // print(insertID.text!)
        friendCollection.document(insertId).addSnapshotListener { (snapshot, error) in
            if let error = error{
                print("Something went wrong! \(error.localizedDescription)")
                return
            }

            if let text = snapshot?.data()?["Location"] as? String {
                print("YES \(text)")
                
                if text == "home" {
                    print("home")
                }else{
                    print("out")
                }
            }
        }
}    

    func GenerateWasTapped() -> String {
        if randomUserID == nil {
        randomUserID = UUID.init().uuidString
        }
        return randomUserID!
    }
}
