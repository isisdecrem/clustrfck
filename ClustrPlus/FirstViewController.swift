

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    func showAlert(message : String, title : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }


    @IBAction func pressed(_ sender: Any) {
        
        if schoolCode.text != nil {
            saveCode()
            performSegue(withIdentifier: "firstSegue", sender: self)
        }
        else{
            self.showAlert(message: "Please enter your school code", title: "Error")
        }
        
    }
    
    @IBOutlet weak var schoolCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForSavedCode()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstSegue"{
            let second = segue.destination as? ViewController
            second!.schoolCode = schoolCode.text!
        }
    }
    
    // Save School Code
    let defaults = UserDefaults.standard
    struct Keys {
        static let schoolCode = "schoolCode"
    }
    
    func saveCode() {
        defaults.set(schoolCode.text, forKey: Keys.schoolCode)
    }
    
    func checkForSavedCode() {
        let code = defaults.value(forKey: Keys.schoolCode) as? String ?? ""
        schoolCode.text = code
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
