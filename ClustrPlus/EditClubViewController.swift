

import UIKit
import Firebase

class EditClubViewController: UIViewController, UITextFieldDelegate {
    var club: Club?
    var ref: DatabaseReference!
    var oldName: String = ""
    var oldDescription: String = ""
    var oldLink: String = ""
    var delegate: EditClubViewControllerDelegate?
    @IBOutlet weak var clubName: UITextField!
    
    
    @IBOutlet weak var clubLink: UITextField!
    
    
    @IBOutlet weak var clubDescription: UITextView!
    
    func showAlert(message : String, title : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "editToClub", sender: self)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let newName = clubName.text
        let newLink = clubLink.text
        let newDescription = clubDescription.text
        print(oldName)
        print(newName)

        if newName != "" && newLink != "" && newDescription != ""{
            if newName != oldName || newDescription != oldDescription || newLink != oldLink {
                ref.child("Clubs").observeSingleEvent(of: .value, with: {
                    snapshot in
                    for child in snapshot.children{
                        if let snapshot = child as? DataSnapshot,
                            let clubItem = Club(snapshot: snapshot){
                            if self.club?.clubId == clubItem.clubId{
                                self.ref.child("Clubs").child(snapshot.key).setValue([ "Club Id" : self.club!.clubId, "Id" : self.club!.id
                                    ,"Club Name" : newName!, "Club Description" : newDescription!, "Club Sign Up Link" : newLink!, "School Code" : self.club?.schoolCode])
                                self.delegate?.finishEditing(club: Club(clubId: self.club!.clubId, id:  self.club!.id, name: newName!, description: newDescription!, signUpLink: newLink!, schoolCode: self.club!.schoolCode))
                                //self.showAlert(message: "The club has been updated", title: "Success")
                                self.performSegue(withIdentifier: "editToClubs", sender: self)

                                break
                            }
                        }
                    }
                })
            }
          
        }
        else {
            showAlert(message: "fill out all fields", title: "Error")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        oldName = club?.name as! String
        oldLink = club?.signUpLink as! String
        oldDescription = club?.description as! String
        clubName.text = oldName
        clubLink.text = oldLink
        clubDescription.text = oldDescription
        ref = Database.database().reference()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        clubDescription.layer.borderWidth = 1
        clubDescription.layer.borderColor = borderColor.cgColor
        clubDescription.layer.cornerRadius = 5.0

    }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if segue.identifier == "editToClub"{
                  let screen = segue.destination as? ClubDetailsAndEditViewController
                  screen?.club = club
              }
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
}




protocol EditClubViewControllerDelegate {
    func finishEditing(club: Club)
}



