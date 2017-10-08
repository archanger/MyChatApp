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
  
  weak var delegate: ChatDataSourceDelegateProtocol?
  var controller = ChatItemsController()
  var currentlyLoading = false
  
  var chatItems: [ChatItemProtocol] {
    return controller.chatItems
  }
  
  var hasMoreNext: Bool {
    return false
  }
  var hasMorePrevious: Bool {
    return controller.loadMore
  }
  
  init(initialMessages: [ChatItemProtocol], uid: String) {
    self.controller.inititalMessages = initialMessages
    self.controller.userUID = uid
    self.controller.loadIntoItemsArray(messageNeeded: min(initialMessages.count, 50), moreLoad: initialMessages.count > 50)
  }
  
  func loadNext() {
    
  }
  
  func loadPrevious() {
    if currentlyLoading == false {
      currentlyLoading = true
      controller.loadPrevious() { [weak self] in
        self?.delegate?.chatDataSourceDidUpdate(self!, updateType: .pagination)
        self?.currentlyLoading = false
      }
    }
  }
  
  func addMessage(message: ChatItemProtocol) {
    self.controller.insertItem(message: message)
    self.delegate?.chatDataSourceDidUpdate(self)
  }
  
  func updateTextMessage(uid: String, status: MessageStatus) {
    if let index = self.controller.chatItems.index(where: { (message) -> Bool in
      return message.uid == uid
    }) {
      let message = self.controller.chatItems[index] as! TextModel
      message.status = status
      self.delegate?.chatDataSourceDidUpdate(self)
    }
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
