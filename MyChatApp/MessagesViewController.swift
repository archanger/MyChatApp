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
import FirebaseDatabaseUI
import Chatto

class MessagesViewController: UIViewController, FUICollectionDelegate, UITableViewDelegate, UITableViewDataSource {
  
  let contacts = FUIArray(query: Database.database().reference().child("Users").child(Me.uid).child("Contacts"))
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.contacts.observeQuery()
    self.contacts.delegate = self
    self.tableView.delegate = self
    self.tableView.dataSource = self
    Database.database().reference().child("User-messages").child(Me.uid).keepSynced(true)
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
        
        let allUpdates =
          ["/Users/\(Me.uid)/Contacts/\(snapshot[index].key)": [
            "email": snapshot[index].value["email"].stringValue,
            "name":snapshot[index].value["name"].stringValue
            ],
           "/Users/\(snapshot[index].key)/Contacts/\(Me.uid)" : [
            "email": Auth.auth().currentUser!.email!,
            "name": Auth.auth().currentUser!.displayName!
            ]
          ]
        
        Database.database().reference().updateChildValues(allUpdates)
        
        self?.alert(message: "Success")
      } else {
        self?.alert(message: "No such email")
      }
    }
  }
}

extension MessagesViewController {
  func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
    self.tableView.beginUpdates()
    self.tableView.insertRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    self.tableView.endUpdates()
  }
  
  func array(_ array: FUICollection, didMove object: Any, from fromIndex: UInt, to toIndex: UInt) {
    self.tableView.beginUpdates()
    self.tableView.insertRows(at: [IndexPath(row: Int(toIndex), section: 0)], with: .automatic)
    self.tableView.deleteRows(at: [IndexPath(row: Int(fromIndex), section: 0)], with: .automatic)
    self.tableView.endUpdates()
  }
  
  func array(_ array: FUICollection, didRemove object: Any, at index: UInt) {
    self.tableView.beginUpdates()
    self.tableView.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    self.tableView.endUpdates()
  }
  
  func array(_ array: FUICollection, didChange object: Any, at index: UInt) {
    self.tableView.beginUpdates()
    self.tableView.reloadRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    self.tableView.endUpdates()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Int(self.contacts.count)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
    let info = JSON((contacts[UInt(indexPath.row)] as? DataSnapshot)?.value as Any).dictionaryObject
    cell.name.text = info?["name"] as? String
    cell.lastMessageDate.text = nil
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let uid = (contacts[UInt(indexPath.row)] as? DataSnapshot)!.key
    let reference = Database.database().reference()
      .child("User-messages")
      .child(Me.uid)
      .child(uid)
      .queryLimited(toLast: 51)
    self.tableView.isUserInteractionEnabled = false
    
    reference.observeSingleEvent(of: .value) {[weak self] (snapshot) in
     
      let messages = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: { (lhs, rhs) -> Bool in
        return lhs["date"].doubleValue < rhs["date"].doubleValue
      })
      let converted = self!.convertToChatItemProtocol(messages: messages)
      let chatLog = ChatLogController()
      chatLog.userUID = uid
      chatLog.datasource = DataSource(initialMessages: converted, uid: uid)
      chatLog.messagesArray = FUIArray(
        query: Database.database()
          .reference()
          .child("User-messages")
          .child(Me.uid)
          .child(uid)
          .queryStarting(atValue: nil, childKey: converted.last!.uid),
        delegate: nil)
      self?.navigationController?.show(chatLog, sender: nil)
      tableView.deselectRow(at: indexPath, animated: true)
      tableView.isUserInteractionEnabled = true
    }
  }
}
