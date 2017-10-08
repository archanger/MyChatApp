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
import FirebaseDatabase
import SwiftyJSON

class ChatItemsController: NSObject {
  
  var chatItems = [ChatItemProtocol]()
  var inititalMessages = [ChatItemProtocol]()
  var loadMore = false
  var userUID: String!
  
  typealias CompletionLoading = () -> Void
  
  func loadIntoItemsArray(messageNeeded: Int, moreLoad: Bool) {
    
    for index in stride(from: inititalMessages.count - chatItems.count, to: inititalMessages.count - chatItems.count - messageNeeded, by: -1) {
      self.chatItems.insert(inititalMessages[index-1], at: 0)
    }
    
    self.loadMore = moreLoad
  }
  
  func insertItem(message: ChatItemProtocol) {
    self.chatItems.append(message)
  }
  
  func loadPrevious(completion: @escaping CompletionLoading) {
    Database.database().reference()
      .child("User-messages")
      .child(Me.uid)
      .child(userUID)
      .queryEnding(atValue: nil, childKey: self.chatItems.first!.uid)
      .queryLimited(toLast: 52)
      .observeSingleEvent(of: .value) {[weak self] (snapshot) in
        var messages = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: { (lhs, rhs) -> Bool in
          return lhs["date"].doubleValue < rhs["date"].doubleValue
        })
        messages.removeLast()
        self?.loadMore = messages.count > 50
        let converted = self!.convertToChatItemProtocol(messages: messages)
        
        for index in stride(from: converted.count, to: converted.count - min(messages.count, 50), by: -1) {
          self?.chatItems.insert(converted[index-1], at: 0)
        }
        
        completion()
    }
    
  }
  
  func adjustWindow() {
    self.chatItems.removeFirst(200)
    self.loadMore = true
  }
}
