//
//  CreateNewEventViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/1/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class CreateNewEventViewController: UIViewController{

    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventDate: UITextField!
    
    @IBOutlet weak var eventTime: UITextField!
    
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var eventExtra: UITextField!
    
    var clubId: Int = 0
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
 
        if title != ""  && date != "" && time != "" && location != "" {
            self.ref.child("Events").childByAutoId().setValue(["Club Id" : clubId ,"Event Title" : title, "Event Date" : date,"Event Time" : time!, "Event Location" : location!, "Event Extra" : extra]){ (error, ref) -> Void in
                self.showAlert(message: "The event has been added", title: "Success")
            }
        }else{
            showAlert(message: "Fill out the form please.", title: "Error")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

    }
    


}
