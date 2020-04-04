//
//  ChatListCell.swift
//  ChatRobot
//
//  Created by 李祺 on 04/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    var chatCellViewModel: ChatListCellViewModel? {
        didSet{
            self.textLabel!.numberOfLines = 0
            self.textLabel!.text = chatCellViewModel?.contentText.replacingOccurrences(of: "|", with: "\n", options: .literal, range: nil)
        }
    }
}
