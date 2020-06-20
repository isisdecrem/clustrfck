

import UIKit
import Firebase

class CreateNewEventViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventDate: UITextField!
    
    @IBOutlet weak var eventTime: UITextField!
    
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var eventExtra: UITextField!
    
    var clubId: Int = 0
    var club: Club!
    var ref: DatabaseReference!
    
    func showAlert(message : String, title : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        let title = eventTitle.text
        let date = eventDate.text
        let time = eventTime.text
        let location = eventLocation.text
        let extra = eventExtra.text ?? ""
        
        if title!.count > 15 && date!.count > 15 && time!.count > 15 && location!.count > 15{
            showAlert(message: "Text is too long. 15 characters max.", title: "Error")
            
        }else if title != ""  && date != "" && time != "" && location != "" {
            self.ref.child("Events").childByAutoId().setValue(["Club Id" : clubId ,"Event Title" : title, "Event Date" : date,"Event Time" : time!, "Event Location" : location!, "Event Extra" : extra]){ (error, ref) -> Void in
                //self.showAlert(message: "The event has been added", title: "Success")
                self.performSegue(withIdentifier: "newEventToClub", sender: self)
            }
            
        }else{
            showAlert(message: "Fill out the form please.", title: "Error")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "newEventToClub", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newEventToClub"{
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
