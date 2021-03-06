

import UIKit
import Firebase

class manageClubsMainscreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var colors = [Color(name: "lightOrange", uiColor: #colorLiteral(red: 0.9571203589, green: 0.7951588035, blue: 0.5279450417, alpha: 1)),
           Color(name: "darkOrange", uiColor: #colorLiteral(red: 0.9413829446, green: 0.6396328807, blue: 0.3576128483, alpha: 1)),
           Color(name: "pink", uiColor: #colorLiteral(red: 0.9843137255, green: 0.6431372549, blue: 0.5294117647, alpha: 1)),
           Color(name: "blue", uiColor: #colorLiteral(red: 0.628890574, green: 0.7048069835, blue: 0.7798258066, alpha: 1)),
           Color(name: "brown", uiColor: #colorLiteral(red: 0.5000930429, green: 0.411888957, blue: 0.3818208575, alpha: 1))]
    
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
        cell.backgroundColor = colors[indexPath.section % 5].uiColor
           cell.layer.borderColor = UIColor.white.cgColor
           cell.layer.borderWidth = 1
           cell.layer.cornerRadius = 8
           cell.clipsToBounds = true
           
        
           tableView.rowHeight = 150

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
            presentDeletionFailsafe(indexPath: indexPath)
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

    func presentDeletionFailsafe(indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete your club?", preferredStyle: .alert)

        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.ref.child("Clubs").child(self.keyArray[indexPath.row]).removeValue()
                self.clubsList.remove(at: indexPath.row)
                self.tableView.reloadData()
                self.keyArray = []
            })
        }

        alert.addAction(yesAction)

        // cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }


}
