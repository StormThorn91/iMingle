//
//  SignUpViewController.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 09/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonCreateMyAccountClicked(_ sender: Any) {
        guard let email = textFieldEmail.text else{
            showRegistrationFailedAlert(details: "Please check your email for errors.")
            return
        }
        guard let password = textFieldPassword.text else{
            showRegistrationFailedAlert(details: "Please check your password for errors.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(data, error) in
            if error != nil{
                // If error is detected.
                self.showRegistrationFailedAlert(details: (error?.localizedDescription)!)
            }else{
                print("Created user successfully.")
            }
        })
    }
    
    func showRegistrationFailedAlert(details: String){
        let alert = UIAlertController(title: "Registration Failed", message: "There was a problem registering your account.\n\nDetails: \(details)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
