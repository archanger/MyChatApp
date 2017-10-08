//
//  MessagesViewController.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 08.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class MessagesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func add(_ sender: Any) {
    self.presentAlert()
  }
  
  @IBAction func signOut(_ sender: Any) {
    try! Auth.auth().signOut()
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  func presentAlert() {
    let alert = UIAlertController(title: "email?", message: "Please write the email:", preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = "Email"
    }
    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {[weak self] _ in
      if let email = alert.textFields?[0].text {
        self?.addContact(email: email)
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func addContact(email: String) {
    Database.database().reference().child("Users").observeSingleEvent(of: .value) {[weak self] (snapshot) in
      let snapshot = JSON(snapshot.value as Any).dictionaryValue
      if let index = snapshot.index(where: { (arg) -> Bool in
        
        let (_, value) = arg
        return value["email"].stringValue == email
      }) {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Contacts").child(snapshot[index].key).updateChildValues(["email": snapshot[index].value["email"].stringValue, "name":snapshot[index].value["name"].stringValue])
        self?.alert(message: "Success")
      } else {
        self?.alert(message: "No such email")
      }
    }
  }
}
