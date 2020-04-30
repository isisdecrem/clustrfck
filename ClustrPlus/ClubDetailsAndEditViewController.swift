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
                   cell.title.textColor = #colorLiteral(red: 0.9413829446, green: 0.6396328807, blue: 0.3576128483, alpha: 1)
                   cell.Description.text = events[indexPath.section].extra
                   cell.Description.textColor = #colorLiteral(red: 0.9413829446, green: 0.6396328807, blue: 0.3576128483, alpha: 1)
                   cell.indexPath = indexPath
                   cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
 //                 cell.datePosted.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            cell.datePosted.isHidden = true
                   cell.layer.borderColor = #colorLiteral(red: 0.9334868789, green: 0.7754582167, blue: 0.5167602897, alpha: 1)
               }else{
            cell.datePosted.isHidden = false 
             
                   cell.title.text = updates[indexPath.section].title
                   cell.Description.text = updates[indexPath.section].update
                   cell.datePosted.text = updates[indexPath.section].datePosted
                   cell.backgroundColor = #colorLiteral(red: 0.9413829446, green: 0.6396328807, blue: 0.3576128483, alpha: 1)
                   cell.title.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                   cell.Description.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                   cell.datePosted.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                   cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
               }
               
               
               
               cell.layer.borderWidth = 1
               cell.layer.cornerRadius = 8
               cell.clipsToBounds = true
               tableView.rowHeight = 200
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
            newEvent?.club = club
            scheduleState = true
          }
        else if segue.identifier == "ShowMakeNewUpdate"{
            let newUpdate = segue.destination as? CreateNewUpdateViewController
            newUpdate?.clubId = club.clubId
            newUpdate?.club = club
            scheduleState = false
        }
        else if segue.identifier == "toEdit"{
            let editEvent = segue.destination  as? EditClubViewController
            editEvent!.club = self.club
            editEvent?.delegate = self
        }
      }
    
    // CODE FOR DELETE
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.scheduleState == true{
                getAllKeys()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when, execute: {
                    self.ref.child("Events").child(self.keyArray[indexPath.row]).removeValue()
                    self.events.remove(at: indexPath.row)
                    tableView.reloadData()
                    self.keyArray = []
                })
            } else {
                getAllKeysU()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when, execute: {
                    self.ref.child("Updates").child(self.keyArrayU[indexPath.row]).removeValue()
                    self.updates.remove(at: indexPath.row)
                    tableView.reloadData()
                    self.keyArrayU = []
                })
                    
            }
                    
        }
            
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    var keyArray:[String] = []
    var keyArrayU:[String] = []

    func getAllKeys() {
        ref?.child("Events").observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    self.keyArray.append(key)

                }
            })

    }
    
    func getAllKeysU() {
        ref?.child("Updates").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArrayU.append(key)

            }
        })
    }

}
