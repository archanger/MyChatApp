//
//  TextBuilder.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import ChattoAdditions
import Chatto

class ViewModel: TextMessageViewModel<TextModel> {
  override init(textMessage: TextModel, messageViewModel: MessageViewModelProtocol) {
    super.init(textMessage: textMessage, messageViewModel: messageViewModel)
  }
}

class TextBuilder: ViewModelBuilderProtocol {

  
  func canCreateViewModel(fromModel model: Any) -> Bool {
    return model is TextModel
  }
  
  func createViewModel(_ model: TextModel) -> ViewModel {
    let textMessageViewModel = ViewModel(textMessage: model, messageViewModel: MessageViewModelDefaultBuilder().createMessageViewModel(model))
    return textMessageViewModel
  }
  
}
