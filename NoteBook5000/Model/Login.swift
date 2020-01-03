//
//  Login.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 03/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class Login {
    
    
    //Email login (Not done)
    func emailLogin(usr:String, pwd:String, caller:UIViewController) {
        Auth.auth().signIn(withEmail: usr, password: pwd) { (result, error) in
            if error == nil {
                print("user logged in")
                
                guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                guard let controller = navController.viewControllers[0] as? HomeController else { return }
                
                controller.loadUserData()
                    
                caller.dismiss(animated: true, completion: nil)
            }else {
                print("some error during \(error.debugDescription)")
            }
        }
    
    }
    
    
}
