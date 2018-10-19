//
//  SearchForPeopleViewController.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 16/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit
import Firebase

class SearchForPeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableViewPeople: UITableView!
    
    @IBOutlet weak var tableViewPeopleBottomConstraint: NSLayoutConstraint!
    
    var userSearchResultArray: [UserSearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewPeople.delegate = self
        tableViewPeople.dataSource = self
        tableViewPeople.register(UINib(nibName: "SearchForPeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchForPeopleTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        textFieldSearch.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @IBAction func buttonCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSearchResultArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchForPeopleViewControllerCell = tableViewPeople.dequeueReusableCell(withIdentifier: "SearchForPeopleTableViewCell", for: indexPath) as! SearchForPeopleTableViewCell
        searchForPeopleViewControllerCell.setContent(name: userSearchResultArray[indexPath.row].name, extraInformation: "\(userSearchResultArray[indexPath.row].location) • \(userSearchResultArray[indexPath.row].sex) • \(userSearchResultArray[indexPath.row].age) years old")
        return searchForPeopleViewControllerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let relationshipDBReference = Database.database().reference().child("relationship")
        
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        
        relationshipDBReference.child(userId).child("grouped conversation").observeSingleEvent(of: .childAdded) { (snapshot) in
            if snapshot.hasChild(self.userSearchResultArray[indexPath.row].uid) {
                // If user has a conversation before with this person.
                
            }else{
                
            }
        }
    }
    
    @objc func textFieldWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            tableViewPeopleBottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc func textFieldWillHide(notification: NSNotification){
        tableViewPeopleBottomConstraint.constant = 0
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        loadSearchResults()
    }
    
    func loadSearchResults(){
        userSearchResultArray.removeAll()
        self.tableViewPeople.reloadData()
        
        let userDBReference = Database.database().reference().child("user")
        userDBReference.removeAllObservers()
        
        guard let textFieldSearchValue = textFieldSearch.text, !textFieldSearchValue.isEmpty else{
            return
        }
        
        userDBReference.queryOrdered(byChild: "name").queryStarting(atValue: textFieldSearchValue).queryEnding(atValue: "\(textFieldSearchValue)\u{f8ff}").observe(
        .childAdded) { (snapshot) in
            guard let userDataDictionary = snapshot.value as? [String: Any] else{
                return
            }
            guard let name = userDataDictionary["name"] as? String else{
                return
            }
            guard let location = userDataDictionary["location"] as? String else{
                return
            }
            guard let sex = userDataDictionary["sex"] as? String else{
                return
            }
            guard let dateOfBirth = userDataDictionary["date of birth"] as? String else{
                return
            }
            
            self.userSearchResultArray.append(UserSearchResult(uid: snapshot.key, name: name, location: location, sex: sex, dateOfBirth: dateOfBirth))
            self.tableViewPeople.reloadData()
        }
    }
}
