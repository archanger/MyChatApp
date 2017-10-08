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

class ChatLogController: BaseChatViewController {

  var presenter: BasicChatInputBarPresenter!
  var datasource: DataSource!
  var decorator = Decorator()
  var userUID: String!
  
  var totalMessages: [ChatItemProtocol] = []
  
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
      let senderID = Auth.auth().currentUser!.uid
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
  }

  func sendOnlineTextMessage(text: String, uid: String, double: Double, senderId: String) {
    let message: [String: Any] = [
      "text": text,
      "uid": uid,
      "date": double,
      "senderID": senderId,
      "status": "success"
    ]
    
    let childUpdates = [
      "/User-messages/\(senderId)/\(self.userUID!)/\(uid)": message,
      "/User-messages/\(self.userUID!)/\(senderId)/\(uid)": message
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

