//
//  ChatListCell.swift
//  ChatRobot
//
//  Created by 李祺 on 04/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class RobotChatCell: UITableViewCell {
    var chatCellViewModel: ChatListCellViewModel? {
        
        didSet{
             robotTextLabel.text = chatCellViewModel?.contentText.replacingOccurrences(of: "|",
                                                                              with: "\n",
                                                                              options: .literal,
                                                                              range: nil)
        }
    }
    
    var robotTextLabel: UILabel = {
        var label = PaddingLabel(withInsets: 10, 10, 18, 18)
        label.backgroundColor = UIColor(red: 0, green: 83/255, blue: 128/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        
        return label
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 0, green: 33/255, blue: 51/255, alpha: 1.0)
        self.addSubview(robotTextLabel)
        setRobotTextLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRobotTextLabelConstraints() {
        
        let robotTextLabelConstraints = [
            robotTextLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            robotTextLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            robotTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -20),
            robotTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10),
        ]
        NSLayoutConstraint.activate(robotTextLabelConstraints)
    }
}


class PaddingLabel: UILabel {
    
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    required init(withInsets top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}
