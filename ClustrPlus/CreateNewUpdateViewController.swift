//
//  CreateNewEventViewController.swift
//  ClustrPlus
//
//  Created by Caleb Kim on 4/9/20.
//  Copyright © 2020 Caleb Kim. All rights reserved.
//

import UIKit
import Firebase

class CreateNewUpdateViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var updateTitle: UITextField!
    
    @IBOutlet weak var updateInfo: UITextView!
    
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
        
        let title = updateTitle.text
        let update = updateInfo.text
        
        let sort = Date()

        let timeInterval = sort.timeIntervalSince1970

        let myInt = Int(timeInterval)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dString = formatter.string(from: Date())
        let sDate = formatter.date(from: dString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let dateString = formatter.string(from: sDate!)
 
        if title!.count > 25 {
            showAlert(message: "Title text is too long. 25 characters max.", title: "Error")
                   
        }else if update!.count > 150{
            showAlert(message: "Description text is too long. 150 characters max.", title: "Error")
        }else if title != ""  && update != "" {
            self.ref.child("Updates").childByAutoId().setValue(["Club Id" : clubId ,"Update Title" : title!, "Update Info" : update!, "Date Posted" : dateString, "Sort by Date" : myInt]){ (error, ref) -> Void in
                //self.showAlert(message: "The update has been posted", title: "Success")
                self.performSegue(withIdentifier: "newUpdateToClub", sender: self)
            }
        }else{
            showAlert(message: "Fill out the form please.", title: "Error")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        updateInfo.layer.borderWidth = 1
        updateInfo.layer.borderColor = borderColor.cgColor
        updateInfo.layer.cornerRadius = 5.0
        updateInfo.text = "Describe your update"
        updateInfo.textColor = UIColor.lightGray
        updateInfo.delegate = self
        

    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if textView.text == "Describe your update" {
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
            textView.text = "Describe your update"
        }
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "newUpdateToClub", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newUpdateToClub"{
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
