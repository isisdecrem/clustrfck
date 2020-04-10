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
   

    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
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

}
