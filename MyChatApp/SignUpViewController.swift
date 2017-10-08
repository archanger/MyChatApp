//
//  SignUpViewController.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var fullName: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(showingKeybord(notification:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard(notification:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func signUp(_ sender: Any) {
    guard let email = email.text, let password = password.text, let fullname = fullName.text else {
      return
    }
    
    Auth.auth().createUser(withEmail: email, password: password) {[weak self] (user, error) in
      if let error = error {
        self?.alert(message:error.localizedDescription)
        return
      }
      
      Database.database().reference().child("Users").child(user!.uid).updateChildValues(["email": email, "name": fullname])
      
      let changeRequest = user!.createProfileChangeRequest()
      changeRequest.displayName = fullname
      changeRequest.commitChanges(completion: nil)
      
      let table = self?.storyboard?.instantiateViewController(withIdentifier: "table")
      self?.navigationController?.show(table!, sender: nil)
    }
  }
}
