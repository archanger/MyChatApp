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
    if let keyboardHeight = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
      self.view.frame.origin.y -= keyboardHeight
    }
  }
  
  @objc func hidingKeyboard(notification: Notification) {
    self.view.frame.origin.y = 0
  }
}
