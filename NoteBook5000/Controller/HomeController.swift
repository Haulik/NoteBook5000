//
//  ViewController.swift
//  NoteBook5000
//
//  Created by Grp5000 on 20/10/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import FirebaseUI
import FirebaseAuth
import Firebase
import UIKit
import GoogleSignIn
import CoreLocation
import UserNotifications

var butikSender = ""
var butikAdmin = ""
let lg = Login()
let lc = Location()
let fb = FirebaseRepo()
let tb = HeadlineTableViewCell()

class HomeController: UIViewController, UNUserNotificationCenterDelegate  {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var adminTest: UIButton!
    
    var userName = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clearer vores regions fra sidste build
        lc.stopMonitor()
        
        lc.setRegion(caller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navController = navigationController else {return}
        adminTest.isHidden = true
        lg.authenticateUserAndConfigureView(caller: self, navController: navController)
    }
    
        
    @IBAction func adminButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goAdmin", sender: self)
    }

    //Logger ud
    @IBAction func signOut(_ sender: Any) {
        guard let navController = navigationController else {return}
        lg.signOut(caller: self, navController: navController)
    }
    
    //Netto knap
    @IBAction func NettoButton(_ sender: UIButton) {
        butikSender = "Netto"
        tb.segueTableView(caller: self)
    }
    //Kvivkly Knap
    @IBAction func KvicklyButton(_ sender: UIButton) {
        butikSender = "Kvickly"
        tb.segueTableView(caller: self)
    }
    //Føtex Knap
    @IBAction func FøtexButton(_ sender: UIButton) {
        butikSender = "Føtex"
        tb.segueTableView(caller: self)
    }
    

}

