//
//  LogInViewController.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 09/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var textFieldUsername: EHTextField!
    @IBOutlet weak var textFieldPassword: EHTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInboxViewController"{
            let destinationViewController = segue.destination as! InboxViewController
            destinationViewController.previousViewController = self
        }
    }
    
    @IBAction func buttonLogInClicked(_ sender: Any) {
        guard let email = textFieldUsername.text else{
            showLogInFailedAlert(details: "Please check your email for errors.")
            return
        }
        guard let password = textFieldPassword.text else{
            showLogInFailedAlert(details: "Please check your password for errors.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(data, error) in
            if error != nil{
                // If error is detected.
                self.showLogInFailedAlert(details: (error?.localizedDescription)!)
            }else{
                self.performSegue(withIdentifier: "segueGoToTabBarController", sender: self)
            }
        })
    }
    
    @IBAction func buttonSignUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "segueGoToSignUp", sender: self)
    }
    
    func showLogInFailedAlert(details: String){
        let alert = UIAlertController(title: "Log In Failed", message: "There was a problem signing in your account.\n\nDetails: \(details)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
