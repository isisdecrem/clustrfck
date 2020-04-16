//
//  ClubDetailsAndEditViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/29/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class ClubDetailsAndEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditClubViewControllerDelegate {
    func finishEditing(club: Club) {
        clubName.text = club.name
        clubLink.text = club.signUpLink
        clubDescription.text = club.description
    }
    
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
            cell.Time.text = events[indexPath.section].time
            cell.Date.text = events[indexPath.section].date
            cell.Location.text = events[indexPath.section].location
            cell.Description.text = events[indexPath.section].extra
            cell.Time.isHidden = false
            cell.Location.isHidden = false
            cell.Date.isHidden = false
            cell.indexPath = indexPath
        }else{
      
            cell.title.text = updates[indexPath.section].title
            cell.Description.text = updates[indexPath.section].update
            cell.Time.isHidden = true
            cell.Location.isHidden = true
            cell.Date.isHidden = true
            cell.indexPath = indexPath
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
    
    @IBAction func newButtonPressed(_ sender: Any) {
        
        if scheduleState == true{
            self.performSegue(withIdentifier: "ShowMakeNewEvent", sender: self)
        }
        else{
             self.performSegue(withIdentifier: "ShowMakeNewUpdate", sender: self)
        }
    }
    
    func loadEvent(){
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
    }
    
    func loadUpdates(){
        ref.child("Updates").queryOrdered(byChild: "Update Title").observe(.value, with: { snapshot
            in
            var newUpdates: [Update] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                let update = Update(snapshot: snapshot){
                    if  update.clubId == self.club.clubId{
                        print("New update posted")
                        newUpdates.append(update)
                    }
                }
            }
            
            self.updates = newUpdates
            self.tableView.reloadData()
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        clubName.text = club.name
        clubLink.text = club.signUpLink
        clubDescription.text = club.description
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        let newEvent = #imageLiteral(resourceName: "New Schedule")
        newButton.setImage(newEvent, for: .normal)
        
        if scheduleState == true {
            loadEvent()
        } else {
            loadUpdates()
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
          //  tableView.reloadData()
            loadEvent()
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
           // tableView.reloadData()
            loadUpdates()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMakeNewEvent"  {
              let newEvent = segue.destination as? CreateNewEventViewController
            newEvent?.clubId = club.clubId
            scheduleState = true
          }
        else if segue.identifier == "ShowMakeNewUpdate"{
            let newUpdate = segue.destination as? CreateNewUpdateViewController
            newUpdate?.clubId = club.clubId
            scheduleState = false
        }
        else if segue.identifier == "toEdit"{
            let editEvent = segue.destination  as? EditClubViewController
            editEvent!.club = self.club
            editEvent?.delegate = self
        }
      }
    
    // CODE FOR DELETE - WORKS FOR EVENTS NOT UPDATES YET
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                if self.scheduleState == true {
                    self.ref.child("Events").child(self.keyArray[indexPath.row]).removeValue()
                    self.events.remove(at: indexPath.row)
                } else {
                    self.ref.child("Updates").child(self.keyArray[indexPath.row]).removeValue()
                    self.updates.remove(at: indexPath.row)
                }
                tableView.reloadData()
                self.keyArray = []
            })
        }
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    var keyArray:[String] = []

    func getAllKeys() {
        if scheduleState == true {
            ref?.child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    self.keyArray.append(key)

                }
            })
        } else{
            ref?.child("Updates").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    self.keyArray.append(key)

                }
            })
        }
    }

}
