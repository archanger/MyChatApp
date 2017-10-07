//
//  DataSource.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class DataSource: ChatDataSourceProtocol {
  
  var delegate: ChatDataSourceDelegateProtocol?
  var controller = ChatItemsController()
  
  var chatItems: [ChatItemProtocol] {
    return controller.chatItems
  }
  
  var hasMoreNext: Bool {
    return false
  }
  var hasMorePrevious: Bool {
    return controller.totalMessages.count - controller.chatItems.count > 0
  }
  
  init(totalMessages: [ChatItemProtocol]) {
    self.controller.totalMessages = totalMessages
    self.controller.loadIntoItemsArray(messageNeeded: min(totalMessages.count, 50))
  }
  
  func loadNext() {
    
  }
  
  func loadPrevious() {
    controller.loadPrevious()
    self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination)
  }
  
  func addMessage(message: ChatItemProtocol) {
    self.controller.insertItem(message: message)
    self.delegate?.chatDataSourceDidUpdate(self)
  }
  
  func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: (Bool) -> Void) {
    if focusPosition > 0.9 {
      self.controller.adjustWindow()
      completion(true)
    } else {
      completion(false)
    }
  }
}
