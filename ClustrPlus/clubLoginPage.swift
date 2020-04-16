//
//  clubLoginPage.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/22/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class clubLoginPage: UIViewController, UITextFieldDelegate {
   
    var schoolCode: String = ""
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "signInSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInSegue"{
            let signUpView = segue.destination as? clubSignUpForAcct
            signUpView!.schoolCode = schoolCode
        }
    }

    
    func showAlert(message : String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        let emailValue = email.text
        let pwValue = password.text
        
        
        if emailValue != ""  && pwValue != ""{
            Auth.auth().signIn(withEmail: emailValue!, password: pwValue!){ (user, error) in
                if error != nil{
                    self.showAlert(message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
        else {
            showAlert(message: "Please enter a username and password.")
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }

}
