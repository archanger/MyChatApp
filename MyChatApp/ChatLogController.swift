//
//  ViewController.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseUI
import SwiftyJSON

class ChatLogController: BaseChatViewController, FUICollectionDelegate {

  var presenter: BasicChatInputBarPresenter!
  var datasource: DataSource!
  var decorator = Decorator()
  var userUID: String!
  var messagesArray: FUIArray!
  
  override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
    let textMessageBuilder = TextMessagePresenterBuilder(viewModelBuilder: TextBuilder(), interactionHandler: TextHandler())
    let photoMessageBuilder = PhotoMessagePresenterBuilder(viewModelBuilder: PhotoBuilder(), interactionHandler: PhotoHandler())
    
    return [TextModel.chatItemType:[textMessageBuilder], PhotoModel.chatItemType:[photoMessageBuilder]]
  }
  
  override func createChatInputView() -> UIView {
    let inputBar = ChatInputBar.loadNib()
    var barAppearence = ChatInputBarAppearance()
    barAppearence.sendButtonAppearance.title = "Send"
    barAppearence.textInputAppearance.placeholderText = "Type a message"
    self.presenter = BasicChatInputBarPresenter(chatInputBar: inputBar, chatInputItems: [handleSend(), handlePhoto()], chatInputBarAppearance: barAppearence)
    return inputBar
  }
  
  func handleSend() -> TextChatInputItem {
    let item = TextChatInputItem()
    item.textInputHandler = {[weak self] text in
      
      let date = Date()
      let double = Double(date.timeIntervalSinceReferenceDate)
      let senderID = Me.uid
      let messageUID: String = "\(double)\(senderID)".replacingOccurrences(of: ".", with: "")
      
      let message = MessageModel(uid: messageUID, senderId: senderID, type: TextModel.chatItemType, isIncoming: false, date: Date(), status: .sending)
      let textMessage = TextModel(messageModel: message, text: text)
      self?.datasource.addMessage(message: textMessage)
      self?.sendOnlineTextMessage(text: text, uid: messageUID, double: double, senderId: senderID)
    }
    
    return item
  }
  
  func handlePhoto() -> PhotosChatInputItem {
    let item = PhotosChatInputItem(presentingController: self)
    item.photoInputHandler = {[weak self] photo in
      let date = Date()
      let double = Double(date.timeIntervalSinceReferenceDate)
      let senderID = "me"
      
      let message = MessageModel(uid: "\(double, senderID)", senderId: senderID, type: PhotoModel.chatItemType, isIncoming: false, date: Date(), status: .success)
      let photoMessage = PhotoModel(messageModel: message, imageSize: photo.size, image: photo)
      
      self?.datasource.addMessage(message: photoMessage)
    }
    
    return item
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.chatDataSource = self.datasource
    self.chatItemsDecorator = self.decorator
    self.constants.preferredMaxMessageCount = 300
    
    self.messagesArray.observeQuery()
    self.messagesArray.delegate = self
  }

  func sendOnlineTextMessage(text: String, uid: String, double: Double, senderId: String) {
    let message: [String: Any] = [
      "text": text,
      "uid": uid,
      "date": double,
      "senderID": senderId,
      "status": "success",
      "type": TextModel.chatItemType
    ]
    
    let childUpdates = [
      "/User-messages/\(senderId)/\(self.userUID!)/\(uid)": message,
      "/User-messages/\(self.userUID!)/\(senderId)/\(uid)": message,
      "/Users/\(Me.uid)/Contacts/\(self.userUID!)/lastMessage" : message,
      "/Users/\(self.userUID!)/Contacts/\(Me.uid)/lastMessage" : message,
    ]
    
    Database.database().reference().updateChildValues(childUpdates) { (error, _) in
      if error != nil {
        self.datasource.updateTextMessage(uid: uid, status: .failed)
        return
      }
      
      self.datasource.updateTextMessage(uid: uid, status: .success)
    }
  }
}

extension ChatLogController {
  func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
    let message = JSON((object as! DataSnapshot).value as Any)
    let contains = self.datasource.chatItems.contains { (cMessage) -> Bool in
      return cMessage.uid == message["uid"].stringValue
    }
    
    if contains == false {
      let senderId = message["senderID"].stringValue
      let model = MessageModel(
        uid: message["uid"].stringValue,
        senderId: senderId,
        type: message["type"].stringValue,
        isIncoming: senderId == Me.uid ? false : true,
        date: Date(timeIntervalSinceReferenceDate: message["date"].doubleValue),
        status: message["status"].stringValue == "success" ? .success : .sending
      )
      let textMessage = TextModel(messageModel: model, text: message["text"].stringValue)
      self.datasource.addMessage(message: textMessage)
    }
  }
}
