

import UIKit
import Firebase

class clubSignUpForAcct: UIViewController, UITextFieldDelegate {
    
    var schoolCode: String = ""
    var ref: DatabaseReference!

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var pwField: UITextField!

    @IBOutlet weak var confirmPwField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
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
                                self.ref.child("User").childByAutoId().setValue(["User Id" : Auth.auth().currentUser?.uid ,"Email" : emailText, "School Code" : self.schoolCode]){ (error, ref) -> Void in
                        
                                }
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
