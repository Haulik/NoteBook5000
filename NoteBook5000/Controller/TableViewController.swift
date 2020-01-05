//
//  TableViewController.swift
//  NoteBook5000
//
//  Created by Grp5000 on 03/12/2019.
//  Copyright © 2019 Grp. 5000. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    var data = [CellData]()
    let fb = FirebaseRepo()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navController = navigationController else {return}
        fb.documentListener(navController: navController)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! HeadlineTableViewCell

        let headline = data[indexPath.row]
        cell.headlineTitleLabel?.text = headline.title
        cell.headlineTextLabel?.text = headline.message
        cell.headlineImageView?.image = headline.image

        return cell
    }

}
