//
//  Helpers.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  @objc func showingKeybord(notification: Notification) {
    if let keyboardHeight = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height, self.view.frame.origin.y >= 0{
      self.view.frame.origin.y -= keyboardHeight
    }
  }
  
  @objc func hidingKeyboard(notification: Notification) {
    self.view.frame.origin.y = 0
  }
  
  func alert(message: String) {
    let alertControler = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertControler.addAction(okAction)
    self.present(alertControler, animated: true, completion: nil)
  }
}
