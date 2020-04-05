//
//  ChatModel.swift
//  ChatRobot
//
//  Created by 李祺 on 03/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

struct ChatModel: Codable {
    var id, text: String
    var replies, payloads, routes: [String]
    var tag, lesson: String
}

struct ChatHistoryModel {
    let contentText: String
    var isRobot: Bool
    var buttons: [ResponseButtonModel]
}

struct ResponseButtonModel {
    let buttonIndex:Int
    let buttonChatID: String
    let buttonText: String
}
