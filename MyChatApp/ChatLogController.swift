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

class ChatLogController: BaseChatViewController {

  var presenter: BasicChatInputBarPresenter!
  var datasource: DataSource!
  var decorator = Decorator()
  
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
    item.textInputHandler = { text in
      
      let date = Date()
      let double = Double(date.timeIntervalSinceReferenceDate)
      let senderID = "me"
      
      let message = MessageModel(uid: "\(double, senderID)", senderId: senderID, type: TextModel.chatItemType, isIncoming: false, date: Date(), status: .success)
      let textMessage = TextModel(messageModel: message, text: text)
      self.datasource.addMessage(message: textMessage)
    }
    
    return item
  }
  
  func handlePhoto() -> PhotosChatInputItem {
    let item = PhotosChatInputItem(presentingController: self)
    item.photoInputHandler = { photo in
      let date = Date()
      let double = Double(date.timeIntervalSinceReferenceDate)
      let senderID = "me"
      
      let message = MessageModel(uid: "\(double, senderID)", senderId: senderID, type: PhotoModel.chatItemType, isIncoming: false, date: Date(), status: .success)
      let photoMessage = PhotoModel(messageModel: message, imageSize: photo.size, image: photo)
      
      self.datasource.addMessage(message: photoMessage)
    }
    
    return item
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for i in 1...295 {
      let message = MessageModel(uid: "\(i)", senderId: "", type: TextModel.chatItemType, isIncoming: false, date: Date(), status: .success)
      self.totalMessages.append(TextModel(messageModel: message, text: "\(i)"))
    }
    
    self.datasource = DataSource(totalMessages: self.totalMessages);
    self.chatDataSource = self.datasource
    self.chatItemsDecorator = self.decorator
    self.constants.preferredMaxMessageCount = 300
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

