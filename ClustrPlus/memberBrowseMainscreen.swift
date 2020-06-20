

import UIKit
import Firebase

class memberBrowseMainscreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var schoolCode: String = ""
    var clubsList: [Club] = []
    
    var ref: DatabaseReference!
    var color1: UIColor = #colorLiteral(red: 0.9571203589, green: 0.7951588035, blue: 0.5279450417, alpha: 1)
    var color2: UIColor = #colorLiteral(red: 0.9398927689, green: 0.6373289227, blue: 0.355412364, alpha: 1)
    var color3: UIColor = #colorLiteral(red: 0.9992339015, green: 0.6548775434, blue: 0.5371440053, alpha: 1)
    var color4: UIColor = #colorLiteral(red: 0.628890574, green: 0.7048069835, blue: 0.7798258066, alpha: 1)
    var color5: UIColor = #colorLiteral(red: 0.5000930429, green: 0.411888957, blue: 0.3818208575, alpha: 1)
    
    var colors = [Color(name: "lightOrange", uiColor: #colorLiteral(red: 0.9571203589, green: 0.7951588035, blue: 0.5279450417, alpha: 1)),
        Color(name: "darkOrange", uiColor: #colorLiteral(red: 0.9413829446, green: 0.6396328807, blue: 0.3576128483, alpha: 1)),
        Color(name: "pink", uiColor: #colorLiteral(red: 0.9843137255, green: 0.6431372549, blue: 0.5294117647, alpha: 1)),
        Color(name: "blue", uiColor: #colorLiteral(red: 0.628890574, green: 0.7048069835, blue: 0.7798258066, alpha: 1)),
        Color(name: "brown", uiColor: #colorLiteral(red: 0.5000930429, green: 0.411888957, blue: 0.3818208575, alpha: 1))
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        ref = Database.database().reference()
        ref.child("Clubs").queryOrdered(byChild: "Club Name").observe(.value, with: { snapshot
            in
            var newClubs: [Club] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                let club = Club(snapshot: snapshot){
                    if club.schoolCode == self.schoolCode{
                        newClubs.append(club)
                    }
                }
            
            }
            
            self.clubsList = newClubs
            self.tableView.reloadData()
        })
        print("member school code:" + schoolCode)
    }
    
 
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let cell = sender as? ClubTableViewCell{
          let detailEditView = segue.destination as? MemberClubViewerViewController
          detailEditView?.club = clubsList[((cell.indexPath?.section)!)]
      }
  }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
   

}
