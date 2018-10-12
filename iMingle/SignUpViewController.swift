//
//  SignUpViewController.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 09/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldSex: UITextField!
    @IBOutlet weak var textFieldDateOfBirth: UITextField!
    
    @IBOutlet weak var textFieldLocation: UITextField!
    
    var sexArray: [String] = ["Male", "Female"]
    
    var textFieldSexFirstTimeEdit = false
    var textFieldDateOfBirthFirstTimeEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleInputTypeForSex()
        handleInputTypeForDateOfBirth()
    }
    
    @IBAction func buttonCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonCreateMyAccountClicked(_ sender: Any) {
        guard let email = textFieldEmail.text, !email.isEmpty else{
            textFieldEmail.becomeFirstResponder()
            showRegistrationFailedAlert(details: "Please check your email for errors.")
            return
        }
        guard let password = textFieldPassword.text, !password.isEmpty else{
            textFieldPassword.becomeFirstResponder()
            showRegistrationFailedAlert(details: "Please check your password for errors.")
            return
        }
        guard let name = textFieldName.text, !name.isEmpty else{
            textFieldName.becomeFirstResponder()
            showRegistrationFailedAlert(details: "Please check your name for errors.")
            return
        }
        guard let sex = textFieldSex.text, !sex.isEmpty else{
            textFieldSex.becomeFirstResponder()
            showRegistrationFailedAlert(details: "Please check your sex for errors.")
            return
        }
        guard let dateOfBirth = textFieldDateOfBirth.text, !dateOfBirth.isEmpty else{
            textFieldDateOfBirth.becomeFirstResponder()
            showRegistrationFailedAlert(details: "Please check your date of birth for errors.")
            return
        }
        guard let location = textFieldLocation.text, !location.isEmpty else{
            textFieldLocation.becomeFirstResponder()
            showRegistrationFailedAlert(details: "Please check your location for errors.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(data, error) in
            if error != nil{
                // If error is detected.
                self.showRegistrationFailedAlert(details: (error?.localizedDescription)!)
            }else{
                Auth.auth().signIn(withEmail: email, password: password, completion: nil)
                guard let userId = Auth.auth().currentUser?.uid else{
                    self.showRegistrationFailedAlert(details: "There was a problem signing in your account.")
                    return
                }
                let userDatabase = Database.database().reference().child("User").child(userId)
                let userData = ["Email":email, "Name":name, "Sex":sex, "Date of Birth":dateOfBirth, "Location":location]
                userDatabase.setValue(userData){
                    (error, reference) in
                    if error != nil{
                        print(userData)
                        self.showRegistrationFailedAlert(details: (error?.localizedDescription)!)
                    }else{
                        print("User successfully registered!")
                    }
                }
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldSex.text = sexArray[row]
    }
    
    func showRegistrationFailedAlert(details: String){
        let alert = UIAlertController(title: "Registration Failed", message: "There was a problem registering your account.\n\nDetails: \(details)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag{
            case 3:
                if(textFieldSexFirstTimeEdit){
                    return;
                }
                textFieldSexFirstTimeEdit = true
                textFieldSex.text = sexArray[0]
                break
            case 4:
                if(textFieldDateOfBirthFirstTimeEdit){
                    return
                }
                textFieldDateOfBirthFirstTimeEdit = true
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                textFieldDateOfBirth.text = dateFormatter.string(from: Date())
                break
            default:
                break
        }
    }
    
    @objc func datePickerDateOfBirthValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        textFieldDateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    
    func handleInputTypeForSex(){
        textFieldSex.delegate = self
        
        let pickerViewSex = UIPickerView()
        pickerViewSex.delegate = self
        pickerViewSex.dataSource = self
        
        textFieldSex.inputView = pickerViewSex
    }
    
    func handleInputTypeForDateOfBirth(){
        textFieldDateOfBirth.delegate = self
        
        let datePickerDateOfBirth = UIDatePicker()
        datePickerDateOfBirth.datePickerMode = .date
        datePickerDateOfBirth.addTarget(self, action: #selector(datePickerDateOfBirthValueChanged(_:)), for: .valueChanged)
        
        textFieldDateOfBirth.inputView = datePickerDateOfBirth
    }
}
