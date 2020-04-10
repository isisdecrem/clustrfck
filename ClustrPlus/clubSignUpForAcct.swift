//
//  clubSignUpForAcct.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 3/22/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit
import Firebase

class clubSignUpForAcct: UIViewController, UITextFieldDelegate {
    
   

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var pwField: UITextField!

    @IBOutlet weak var confirmPwField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    func showAlert(message : String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let emailText = emailField.text
        let  pwText = pwField.text
        let confirmPwText = confirmPwField.text
        
        if emailText != "" && pwText != "" &&  confirmPwText != "" {
            if  pwText == confirmPwText {
                Auth.auth().createUser(withEmail: emailText!, password: pwText!)
                           { (user, error) in
                               if (error == nil)
                               {
                                self.performSegue(withIdentifier: "signUpSegue", sender: self)
                               }else{
                                self.showAlert(message: error!.localizedDescription)
                            }
                           }
            }
            else{
                showAlert(message: "The passwords do not match.")
            }
           
        }else{
            showAlert(message: "Please fill in all the fields to sign up.")
        }
        
    }
    
    func alertShowMethod(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
