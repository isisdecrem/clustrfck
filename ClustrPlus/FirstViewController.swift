//
//  FirstViewController.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/19/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    func showAlert(message : String, title : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }


    @IBAction func pressed(_ sender: Any) {
        
        if schoolCode.text != nil {
             performSegue(withIdentifier: "firstSegue", sender: self)
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
        if segue.identifier == "firstSegue"{
            let second = segue.destination as? ViewController
            second!.schoolCode = schoolCode.text!
        }
    }




}
