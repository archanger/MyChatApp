//
//  SignInViewController.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
  
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(showingKeybord(notification:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard(notification:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  @IBAction func signIn(_ sender: Any) {
    guard let email = email.text, let password = password.text else {
      return
    }
    
    Auth.auth().signIn(withEmail: email, password: password) {[weak self] (user, error) in
      if let error = error {
        self?.alert(message:error.localizedDescription)
        return
      }
      
      let table = self?.storyboard?.instantiateViewController(withIdentifier: "table")
      self?.navigationController?.show(table!, sender: nil)
    }
  }
  
  @IBAction func signUp(_ sender: Any) {
    let controller = storyboard?.instantiateViewController(withIdentifier: "SIGNUP") as! SignUpViewController
    
    self.navigationController?.show(controller, sender: nil)
  }
  
  
}
