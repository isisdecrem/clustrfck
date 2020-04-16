//
//  manageClubsMainscreen.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/22/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class manageClubsMainscreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func logoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(identifier: "NavControl") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
        }
    }
    var clubsList: [Club] = []
    
    var ref: DatabaseReference!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ClubTableViewCell
        cell.clubNameLabel.text = clubsList[indexPath.section].name
        cell.indexPath = indexPath
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return clubsList.count
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        ref = Database.database().reference()
        let userId = (Auth.auth().currentUser?.uid)!
        ref.child("Clubs").queryOrdered(byChild: "Club Name").observe(.value, with: { snapshot
            in
            var newClubs: [Club] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                let club = Club(snapshot: snapshot){
                    if club.id == userId{
                        newClubs.append(club)
                    }
                }
            }
            
            self.clubsList = newClubs
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ClubTableViewCell{
            let detailEditView = segue.destination as? ClubDetailsAndEditViewController
            detailEditView?.club = clubsList[((cell.indexPath?.section)!)]
        }
    }
    
 //CODE FOR DELETING CLUBS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.ref.child("Clubs").child(self.keyArray[indexPath.row]).removeValue()
                self.clubsList.remove(at: indexPath.row)
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

        ref?.child("Clubs").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)

                }
            })

    }


}
