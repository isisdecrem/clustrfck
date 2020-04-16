//
//  makeClubViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/27/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class makeClubViewController: UIViewController {
    var ref : DatabaseReference!
    
    
    @IBOutlet weak var clubNameField: UITextField!
    
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var linkField: UITextField!
    
    func showAlert(message : String, title : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let clubName = clubNameField.text
        let description = descriptionField.text
        let signUpLink = linkField.text
        let userId = (Auth.auth().currentUser?.uid)!
        //generates unique club ID from current time in millisecs
        let clubId = Int(NSDate.timeIntervalSinceReferenceDate * 1000)
        
        if clubName != ""  && description != "" && signUpLink != "" {
            self.ref.child("Clubs").childByAutoId().setValue([ "Club Id" : clubId, "Id" : userId,"Club Name" : clubName!, "Club Description" : description!, "Club Sign Up Link" : signUpLink]){ (error, ref) -> Void in
                self.showAlert(message: "The club has been added", title: "Success")
            }
        }else{
            showAlert(message: "Fill out the form please.", title: "Error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.borderColor = borderColor.cgColor
        descriptionField.layer.cornerRadius = 5.0       
    }

}
