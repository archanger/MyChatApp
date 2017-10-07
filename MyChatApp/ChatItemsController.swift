//
//  ChatItemsController.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class ChatItemsController {
  
  var chatItems = [ChatItemProtocol]()
  var totalMessages = [ChatItemProtocol]()
  
  func loadIntoItemsArray(messageNeeded: Int) {
    
    for index in stride(from: totalMessages.count - chatItems.count, to: totalMessages.count - chatItems.count - messageNeeded, by: -1) {
      self.chatItems.insert(totalMessages[index-1], at: 0)
    }
  }
  
  func insertItem(message: ChatItemProtocol) {
    self.chatItems.append(message)
    self.totalMessages.append(message)
  }
  
  func loadPrevious() {
    self.loadIntoItemsArray(messageNeeded: min(totalMessages.count - chatItems.count, 50))
  }
  
  func adjustWindow() {
    self.chatItems.removeFirst(200)
  }
}
