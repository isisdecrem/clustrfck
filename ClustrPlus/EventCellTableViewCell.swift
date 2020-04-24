//
//  EventCellTableViewCell.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/1/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit

class EventCellTableViewCell: UITableViewCell {

    @IBOutlet weak var datePosted: UILabel!
    @IBOutlet weak var title: UILabel!
    var indexPath: IndexPath!
    
    @IBOutlet var Description: UILabel!
    
}
