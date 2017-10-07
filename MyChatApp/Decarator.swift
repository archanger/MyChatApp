//
//  Decarator.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class Decorator: ChatItemsDecoratorProtocol {
  
  func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
    var decoratedChatItems = [DecoratedChatItem]()
    
    for item in chatItems {
      let decoratedItem = DecoratedChatItem(chatItem: item, decorationAttributes: ChatItemDecorationAttributes(bottomMargin: 3, canShowTail: false, canShowAvatar: false, canShowFailedIcon: false))
      decoratedChatItems.append(decoratedItem)
    }
    
    return decoratedChatItems
  }
  
}
