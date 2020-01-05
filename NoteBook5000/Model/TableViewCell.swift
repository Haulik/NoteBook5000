//
//  TableViewCell.swift
//  NoteBook5000
//
//  Created by Grp5000 on 05/01/2020.
//  Copyright © 2020 Grp. 5000. All rights reserved.
//

import Foundation
import UIKit

class HeadlineTableViewCell: UITableViewCell {

    @IBOutlet weak var headlineTitleLabel: UILabel!
    @IBOutlet weak var headlineTextLabel: UILabel!
    @IBOutlet weak var headlineImageView: UIImageView!
    
    func segueTableView(caller:UIViewController){
        caller.performSegue(withIdentifier: "tableView", sender: self)
    }
}
