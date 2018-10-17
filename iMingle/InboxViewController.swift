//
//  InboxViewController.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 11/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit
import Firebase

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var previousViewController: UIViewController?
    
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableViewMessage: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposePreviousViewController()
        
        tableViewMessage.delegate = self
        tableViewMessage.dataSource = self
        tableViewMessage.register(UINib(nibName: "InboxTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxTableViewCell")
    }
    
    func disposePreviousViewController(){
        previousViewController?.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewMessage.dequeueReusableCell(withIdentifier: "InboxTableViewCell", for: indexPath) as! InboxTableViewCell
        return cell
    }
    
    @IBAction func buttonComposeMessageClicked(_ sender: Any) {
        performSegue(withIdentifier: "segueGoToSearchForPeople", sender: self)
    }
    
    @IBAction func buttonSettingsClicked(_ sender: Any) {
        
    }
    
}
