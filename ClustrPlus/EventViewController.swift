//
//  UpdateViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/19/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    
    var event: Event?
    var update: Update?
    
  
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var des: UILabel!
    
    
    @IBOutlet weak var location: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
            
            
        }
        
    }
    
    
    
    

}
