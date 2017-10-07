//
//  TextModel.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import ChattoAdditions
import Chatto

class TextModel: TextMessageModel<MessageModel> {
  
  static let chatItemType = "text"
  
  override init(messageModel: MessageModel, text: String) {
    super.init(messageModel: messageModel, text: text)
  }
}
