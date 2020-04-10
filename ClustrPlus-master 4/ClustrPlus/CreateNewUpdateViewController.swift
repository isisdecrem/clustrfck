//
//  CreateNewEventViewController.swift
//  ClustrPlus
//
//  Created by Caleb Kim on 4/9/20.
//  Copyright © 2020 Isis Decrem, Caleb Kim. All rights reserved.
//

import UIKit
import Firebase

class CreateNewUpdateViewController: UIViewController{

    @IBOutlet weak var updateTitle: UITextField!
    
    @IBOutlet weak var updateInfo: UITextView!
    
    var clubId: Int = 0
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
 
        if title != ""  && update != "" {
            self.ref.child("Updates").childByAutoId().setValue(["Club Id" : clubId ,"Update Title" : title!, "Update Info" : update!]){ (error, ref) -> Void in
                self.showAlert(message: "The update has been posted", title: "Success")
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
