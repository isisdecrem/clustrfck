//
//  MemberClubViewerViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/30/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class MemberClubViewerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var events: [Event] = []
    var updates: [Update] = []
    var ref: DatabaseReference!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        if scheduleState == true {
            print(events.count)
            return events.count
        } else{
            return updates.count
        }
            
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCellTableViewCell
        if scheduleState == true {
            print("I am here")
            cell.title.text = events[indexPath.section].title
            cell.indexPath = indexPath
        }else{
            //cant do this until the updates file has variables w/ names
//           cell.title.text = updates[indexPath.section].name
//           cell.indexPath = indexPath
        }
            
        return cell
            
    }
    
    

   var club: Club!
   var scheduleState = true
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clubName: UILabel!
    
    @IBOutlet weak var clubLink: UILabel!
    
    @IBOutlet weak var updateB: UIButton!
    @IBOutlet weak var scheduleB: UIButton!
    
    @IBOutlet weak var clubDescription: UITextView!
    
    @IBOutlet weak var newButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        clubName.text = club.name
        clubLink.text = club.signUpLink
        clubDescription.text = club.description
        tableView.dataSource = self
        tableView.delegate = self
        let newEvent = #imageLiteral(resourceName: "New Schedule")
        newButton.setImage(newEvent, for: .normal)
        
        if scheduleState == true {
        ref.child("Events").queryOrdered(byChild: "Event Title").observe(.value, with: { snapshot
            in
            var newEvents: [Event] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                let event = Event(snapshot: snapshot){
                    if  event.clubId == self.club.clubId{
                        print("New event added")
                        newEvents.append(event)
                    }
                }
            }
            
            self.events = newEvents
            self.tableView.reloadData()
        })
        } else {
            // load the updates
        }
    }
    
    @IBAction func schedulePress () {
        if scheduleState == false {
            let SD = #imageLiteral(resourceName: "Schedule Selected")
            let UL = #imageLiteral(resourceName: "Updates Unselected")
            scheduleB.setImage(SD, for: .normal)
            updateB.setImage(UL, for: .normal)
            scheduleState = true
            let newEvent = #imageLiteral(resourceName: "New Schedule")
            newButton.setImage(newEvent, for: .normal)
        
        }
    }
    
    @IBAction func updatePress(){
        if scheduleState {
            let SL = #imageLiteral(resourceName: "Schedule Unselected")
            let UD = #imageLiteral(resourceName: "Updates Selected")
            scheduleB.setImage(SL, for: .normal)
            updateB.setImage(UD, for: .normal)
            scheduleState = false
            let newUpdate = #imageLiteral(resourceName: "New Update")
            newButton.setImage(newUpdate, for: .normal)
            
        }
    }
    



}
