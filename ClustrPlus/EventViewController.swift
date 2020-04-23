//
//  UpdateViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/19/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel:
    UILabel!
    
    
    var event: Event?
    var update: Update?
    var club: Club?
    
    
  
    @IBOutlet weak var clubName: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var des: UILabel!
    
    
    @IBOutlet weak var location: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        clubName.text = club?.name
        
        if event != nil{
            name.text = event?.title
            date.text = event?.date
            time.text = event?.time
            des.text = event?.extra
            location.text = event?.location
        }
        
        else if update != nil{
            name.text = update?.title
            des.text = update?.update
            time.isHidden = true
            date.isHidden = true
            location.isHidden = true
            timeLabel.isHidden = true
            dateLabel.isHidden = true
            locationLabel.isHidden = true
            
            
        }
        
    }
    
    
    
    

}
