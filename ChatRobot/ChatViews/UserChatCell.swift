//
//  UserChatCell.swift
//  ChatRobot
//
//  Created by 李祺 on 05/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class UserChatCell: UITableViewCell {
    var chatCellViewModel: ChatListCellViewModel? {
        
        didSet{
            userTextLabel.text = chatCellViewModel?.contentText
        }
    }
    
    var userTextLabel: UILabel = {
        var label = PaddingLabel(withInsets: 10, 10, 18, 18)
        label.backgroundColor = UIColor(red: 0, green: 128/255, blue: 0/255, alpha: 1.0)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.textColor = .white

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 0, green: 33/255, blue: 51/255, alpha: 1.0)
        self.addSubview(userTextLabel)
        setUserTextLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUserTextLabelConstraints() {
        
        let userTextLabelConstraints = [
            userTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            userTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10),
            userTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -5),

        ]
        NSLayoutConstraint.activate(userTextLabelConstraints)
    }
}

