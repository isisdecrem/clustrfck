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
            cell.title.textColor = #colorLiteral(red: 0.9413829446, green: 0.6396328807, blue: 0.3576128483, alpha: 1)
            cell.Description.text = events[indexPath.section].extra
            cell.Description.textColor = #colorLiteral(red: 0.9413829446, green: 0.6396328807, blue: 0.3576128483, alpha: 1)
            cell.indexPath = indexPath
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.datePosted.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            cell.layer.borderColor = #colorLiteral(red: 0.9334868789, green: 0.7754582167, blue: 0.5167602897, alpha: 1)
        }else{
      
            cell.title.text = updates[indexPath.section].title
            cell.Description.text = updates[indexPath.section].update
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
    // Set the spacing between sections
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 15
       }

       // Make the background color show through
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
       }
    
    

   var club: Club!
   var scheduleState = true
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clubName: UILabel!
    
    @IBOutlet weak var datePosted: UILabel!
    
    
    @IBOutlet weak var clubLink: UILabel!
    
    @IBOutlet weak var updateB: UIButton!
    @IBOutlet weak var scheduleB: UIButton!
    
    @IBOutlet weak var clubDescription: UITextView!
    
 
    
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
            loadUpdates()
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if scheduleState == true{
            if let cell = sender as? EventCellTableViewCell{
                let viewUpdate = segue.destination as? EventViewController
                viewUpdate?.event = events[((cell.indexPath?.section)!)]
                viewUpdate?.club = club
            }
        }
        else{
            if let cell = sender as? EventCellTableViewCell{
                let viewUpdate = segue.destination as? EventViewController
                viewUpdate?.update = updates[((cell.indexPath?.section)!)]
                viewUpdate?.club = club
            }
        }
        
    }



}
