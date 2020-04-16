//
//  ViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/22/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func memberPressed(_ sender: Any) {
         var code = schoolCode.text
               if code != ""{
                   performSegue(withIdentifier: "memberSegue", sender: self)
               }
               else{
                   self.showAlert(message: "Please enter your school code", title: "Error")
               }
    }
    
    func showAlert(message : String, title : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func adminPressed(_ sender: Any) {
        var code = schoolCode.text
        if code != ""{
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
        else{
            self.showAlert(message: "Please enter your school code", title: "Error")
        }
        
    }
    
    
    @IBOutlet weak var schoolCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue"{
            let loginView = segue.destination as? clubLoginPage
            loginView!.schoolCode = schoolCode.text!
        }else if segue.identifier == "memberSegue"{
            let clubView = segue.destination as? memberBrowseMainscreen
            clubView!.schoolCode = schoolCode.text!
        }
    }


}

