//
//  TableViewController.swift
//  NoteBook5000
//
//  Created by Thomas Haulik Barchager on 03/12/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase

struct CellData {
    var image : UIImage?
    var message : String
    var imageTekst: String
    
}

class TableViewController: UITableViewController {

    var data = [CellData]()
    var test = [Any]()
    private var noteListener : ListenerRegistration?
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* let storageRef = Storage.storage().reference(withPath: "Picture/72B8C4DE-79AF-4515-ABE6-C382A894DBED.jpg")
        let taskReference = storageRef.getData(maxSize: 6 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Something went wrong: \(error.localizedDescription)")
                return
            }
            if let data = data{
               // self?.dataImage.image = UIImage(data: data)
                let pic = UIImage(data: data)
                
            }
        } */
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startNoteListener()
        if butikSender == "Netto" {
            print("netto")
            //Do something
        /*    data = [CellData.init(image: UIImage(named: "Fugl"), message: "Jonathan is that you?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired"), CellData.init(image: UIImage(named: "Jeudan"), message: "How?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired")] */
 
        }
        else if butikSender == "Kvickly" {
            print("Kvickly")
            //Do somthing
           /* data = [CellData.init(image: UIImage(named: "Fugl"), message: "Thomas is that you?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired"), CellData.init(image: UIImage(named: "Jeudan"), message: "How?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired")] */
        }
            
        else if butikSender == "Føtex" {
            print("Føtex")
            //Do something
           // LoadPicture()
        }
        
    }
    
    func LoadPicture(){
        let storageRef = Storage.storage().reference(withPath: "Picture/96E6548F-4C79-4BD3-B34B-DFCE56A309BE.jpg")
        storageRef.getData(maxSize: 6 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Something went wrong: \(error.localizedDescription)")
                return
            }
            if let data = data{
               // self?.dataImage.image = UIImage(data: data)
                let pic = UIImage(data: data)
               /* self?.data = [CellData.init(image: pic, message: "Gustav is that you?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired"), CellData.init(image: UIImage(named: "Jeudan"), message: "How?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired")] */
                print("test")
   
            }
            self?.tableView.reloadData()
        }
        
    }
    
    func startNoteListener() {
        print("startNoteListener called")
        noteListener = Firestore.firestore().collection("notes").addSnapshotListener({ (snapshot, error) in
                print("received snapshot")
            self.data.removeAll()
            for document in snapshot!.documents {
                
                //if let titel = document.data()["titel"] as? String,
                   if let tekst = document.data()["tekst"] as? String,
                    let imageName = document.data()["image"] as? String{
                    let note = CellData(message: tekst, imageTekst: imageName)
                    self.data.append(note)
                }
            }
            
            DispatchQueue.main.async {
                for note in self.data {
                    self.downloadImage(filename: note.imageTekst, note: note)
                }
            }
        })
        
    }
    
    
    
    func downloadImage(filename:String, note:CellData)  {
        // Create a reference with an initial file path and name
        let pathReference = Storage.storage().reference(withPath: filename) // "Picture/\(butikSender)/\(randomID).jpg"
        var image:UIImage?
        pathReference.getData(maxSize: 4000*4000) { (data, error) in
            if error != nil {
                print("error downloading file \(error.debugDescription)")
            }else{
                image = UIImage(data: data!)
               // self.imageView.image = image
                var note = note
                note.image = image
                //self.data.append(CellData.init(image: image, message: note, imageTekst: "Test"))
                //self.data.append(note.image)
                print("success in downloading image \(image?.size)")
                
            }
            self.tableView.reloadData()
        }
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.mainImage = data[indexPath.row].image
        cell.message = data[indexPath.row].message
        cell.layoutSubviews()
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

}
