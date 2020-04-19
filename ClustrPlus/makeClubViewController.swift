//
//  makeClubViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/27/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class makeClubViewController: UIViewController, UITextViewDelegate{
    var ref : DatabaseReference!
    var schoolCode: String = ""
    
    
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
            self.ref.child("Clubs").childByAutoId().setValue([ "Club Id" : clubId, "Id" : userId,"Club Name" : clubName!, "Club Description" : description!, "Club Sign Up Link" : signUpLink, "School Code" : schoolCode]){ (error, ref) -> Void in
                self.showAlert(message: "The club has been added", title: "Success")
            }
        }else{
            showAlert(message: "Fill out the form please.", title: "Error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.ref?.child("User").observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let userItem = User(snapshot: snapshot) {
                    if userItem.uId == Auth.auth().currentUser?.uid {
                        self.schoolCode = userItem.schoolCode
                    }
                }
            }
        })
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.borderColor = borderColor.cgColor
        descriptionField.layer.cornerRadius = 5.0
        descriptionField.text = "Describe your club"
        descriptionField.textColor = UIColor.lightGray
        descriptionField.delegate = self
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if textView.text == "Describe your club" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textView (_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Describe your club"
        }
        
    }

}
