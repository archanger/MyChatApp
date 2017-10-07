//
//  PhotoBuilder.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 07.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class PhotoBuilder: ViewModelBuilderProtocol {
  func canCreateViewModel(fromModel model: Any) -> Bool {
    return model is PhotoModel
  }
  
  func createViewModel(_ model: PhotoModel) -> PhotoViewModel {
    let photoMessageViewModel = PhotoViewModel(photoMessage: model, messageViewModel: MessageViewModelDefaultBuilder().createMessageViewModel(model))
    return photoMessageViewModel
  }
}

class PhotoViewModel: PhotoMessageViewModel<PhotoModel> {
  
  override init(photoMessage: PhotoModel, messageViewModel: MessageViewModelProtocol) {
    super.init(photoMessage: photoMessage, messageViewModel: messageViewModel)
  }
  
}
