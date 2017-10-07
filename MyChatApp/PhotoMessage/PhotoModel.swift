//
//  PhotoModel.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class PhotoModel: PhotoMessageModel<MessageModel> {
  
  static let chatItemType = "photo"
  
  override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
    super.init(messageModel: messageModel, imageSize: imageSize, image: image)
  }
}
