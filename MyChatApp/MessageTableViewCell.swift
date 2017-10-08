//
//  MessageTableViewCell.swift
//  MyChatApp
//
//  Created by Кирилл Чуянов on 08.10.2017.
//  Copyright © 2017 Кирилл Чуянов. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var lastMessage: UILabel!
  @IBOutlet weak var lastMessageDate: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
