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
    let image : UIImage?
    let message : String?
    
}

class TableViewController: UITableViewController {

    var data = [CellData]()
    

    

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
        
        
        data = [CellData.init(image: UIImage(named: "Fugl"), message: "Jonathan is that you?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired"), CellData.init(image: UIImage(named: "Jeudan"), message: "How?"), CellData.init(image: UIImage(named: "Jeudan"), message: "How not to get fired")]
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150

        
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
