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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSearchResultArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchForPeopleViewControllerCell = tableViewPeople.dequeueReusableCell(withIdentifier: "SearchForPeopleTableViewCell", for: indexPath) as! SearchForPeopleTableViewCell
        searchForPeopleViewControllerCell.setContent(name: userSearchResultArray[indexPath.row].name, extraInformation: "\(userSearchResultArray[indexPath.row].location) • \(userSearchResultArray[indexPath.row].sex) • \(userSearchResultArray[indexPath.row].age) years old")
        return searchForPeopleViewControllerCell
    }
    
    func loadSearchResults(){
        userSearchResultArray.removeAll()
        self.tableViewPeople.reloadData()
        
        guard let textFieldSearchValue = textFieldSearch.text, !textFieldSearchValue.isEmpty else{
            return
        }
        
        let userDBReference = Database.database().reference().child("User").queryOrdered(byChild: "Name").queryStarting(atValue: textFieldSearchValue).queryEnding(atValue: "\(textFieldSearchValue)\\uf8ff").observe(.childAdded) { (snapshot) in
            print(snapshot.value)
            guard let userDataDictionary = snapshot.value as? [String: Any] else{
                return
            }

            guard let name = userDataDictionary["Name"] as? String else{
                return
            }
            guard let location = userDataDictionary["Location"] as? String else{
                return
            }
            guard let sex = userDataDictionary["Sex"] as? String else{
                return
            }
            guard let dateOfBirth = userDataDictionary["Date of Birth"] as? String else{
                return
            }
            self.userSearchResultArray.append(UserSearchResult(name: name, location: location, sex: sex, dateOfBirth: dateOfBirth))
            self.tableViewPeople.reloadData()
        }
        
    }
}
