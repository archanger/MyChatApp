//
//  Me.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 08.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import FirebaseAuth

class Me {
  static var uid: String {
    return Auth.auth().currentUser!.uid
  }
}
