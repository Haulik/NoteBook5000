//
//  TableViewController.swift
//  NoteBook5000
//
//  Created by Grp5000 on 03/12/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase

struct CellData {
    var image : UIImage?
    var message : String
    var imageTekst: String?
}

class TableViewController: UITableViewController {

    var fb = FirebaseRepo()
    var data = [CellData]()
    public var noteListener : ListenerRegistration?
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        guard let navController = navigationController else {return}
        fb.startNoteListener(navController: navController)
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
