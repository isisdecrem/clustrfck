

import UIKit



class ViewController: UIViewController {
    var schoolCode: String = ""
    
    
    @IBAction func memberPressed(_ sender: Any) {
        performSegue(withIdentifier: "memberSegue", sender: self)
               
    }
    
    
    @IBAction func adminPressed(_ sender: Any) {
     
            performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("school code is" + schoolCode)
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue"{
            let loginView = segue.destination as? clubLoginPage
            loginView!.schoolCode = self.schoolCode
        }else if segue.identifier == "memberSegue"{
            let clubView = segue.destination as? memberBrowseMainscreen
            clubView!.schoolCode = self.schoolCode
        }
    }


}

