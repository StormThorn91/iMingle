//
//  FirebaseDatabaseController.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 19/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDatabaseController{
    static func registerNewUser(email: String, password: String, name: String, sex: String, dateOfBirth: String, location: String, registrationCompleteHandler: @escaping () -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if error != nil{
                print("FDC Error: User's data has not been successfully stored inside the child of user. Check error at registerNewUser(). #1")
            }else{
                Auth.auth().signIn(withEmail: email, password: password, completion: { (data, error) in
                    if error != nil{
                        print("FDC Error: User's data has not been successfully stored inside the child of user. Check error at registerNewUser(). #2")
                    }else{
                        guard let userId = Auth.auth().currentUser?.uid else{
                            print("FDC Error: User's data has not been successfully stored inside the child of user. Check the variable 'userId' at registerNewUser(). #3")
                            return
                        }
                        
                        let userDBReference = Database.database().reference().child("user").child(userId)
                        let userDataDictionary = ["user id":userId, "email":email, "name":name, "sex":sex, "date of birth":dateOfBirth, "location":location]
                        
                        userDBReference.setValue(userDataDictionary){
                            (error, reference) in
                            if error != nil{
                                print("FDC Error: User's data has not been successfully stored inside the child of user. Check error at registerNewUser(). #4")
                            }else{
                                registrationCompleteHandler()
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func getUserData(withUserId userId: String, completion: @escaping (_ userData: [String: String]) -> Void){
        let userDBReference = Database.database().reference().child("user")
        userDBReference.queryOrdered(byChild: "user id").queryEqual(toValue: userId).observeSingleEvent(of: .childAdded) { (snapshot) in
            if snapshot.value != nil{
                guard let userDataResult = snapshot.value as? [String: Any] else{
                    print("FDC Error: There was a problem retrieving the user data. Check the variable 'userDataResult' at getUserData().")
                    return
                }
                guard let userId = userDataResult["user id"] as? String else{
                    print("FDC Error: There was a problem retrieving the user data. Check the variable 'userId' at getUserData().")
                    return
                }
                guard let email = userDataResult["email"] as? String else{
                    print("FDC Error: There was a problem retrieving the user data. Check the variable 'email' at getUserData().")
                    return
                }
                guard let name = userDataResult["name"] as? String else{
                    print("FDC Error: There was a problem retrieving the user data. Check the variable 'name' at getUserData().")
                    return
                }
                guard let sex = userDataResult["sex"] as? String else{
                    print("FDC Error: There was a problem retrieving the user data. Check the variable 'sex' at getUserData().")
                    return
                }
                guard let dateOfBirth = userDataResult["date of birth"] as? String else{
                    print("FDC Error: There was a problem retrieving the user data. Check the variable 'dateOfBirth' at getUserData().")
                    return
                }
                guard let location = userDataResult["location"] as? String else{
                    print("FDC Error: There was a problem retrieving the user data. Check the variable 'location' at getUserData().")
                    return
                }
                
                let userDataResultFiltered : [String: String] = ["user id":userId, "email":email, "name":name, "sex":sex, "date of birth":dateOfBirth, "location":location]
                completion(userDataResultFiltered)
            }else{
                print("FDC Error: There was a problem retrieving the user data. Check error at at getUserData().")
            }
        }
    }
}


