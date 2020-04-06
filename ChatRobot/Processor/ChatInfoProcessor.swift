//
//  ChatInfoProcessor.swift
//  ChatRobot
//
//  Created by 李祺 on 04/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

final class ChatInfoProcessor {
    let chatScheme: [ChatModel]
    let startTag = "allornothing-start"
    let endTag = "bye"
    
    init(chatScheme:[ChatModel]) {
        self.chatScheme = chatScheme
    }
    
    func findStartChat() -> Result<ChatHistoryModel, ChatServiceError> {
        for item in chatScheme {
            if item.tag == startTag {
                let buttonModelArray = returnButtonArray(with: item)
                return .success(ChatHistoryModel(contentText: item.text, isRobot: true, buttons: buttonModelArray))
            }
        }
        
        return .failure(.noStartChat)
    }
    
    /// Find the next chat object accroding to the id and index.
    ///
    /// - Author: Qi Li
    ///
    /// - Returns: result with chat object or error
    ///
    /// - Parameters:
    ///     - chatID: the id in ChatModel
    ///     - buttonIndex: the button  index when user click the button
    ///
    ///  - Important: If the contentText in ChatHistoryModel is "end", that means it has reached the last chat
    ///
    ///  - Version: 0.1
    
    func findNextChat(withID chatID:String, andIndex buttonIndex:Int) -> Result<ChatHistoryModel, ChatServiceError> {
        do {
            let nextChatID = try findNextChatID(chatID: chatID, buttonIndex: buttonIndex).get()
            
            if nextChatID == "end" {
                return .success(ChatHistoryModel(contentText: nextChatID,
                                                 isRobot: true,
                                                 buttons: [] ))
            }
            
            for item in chatScheme {
                if item.id == nextChatID {
                    let buttonModelArray = returnButtonArray(with: item)
                    return .success(ChatHistoryModel(contentText: item.text,
                                                     isRobot: true,
                                                     buttons: buttonModelArray))
                }
            }
        } catch {
            return .failure(.noNextChat)
        }
        
        return .failure(.noNextChat)
    }
    
    private func findNextChatID(chatID:String, buttonIndex:Int) -> Result<String, ChatServiceError> {
        for item in chatScheme {
            if item.id == chatID {
                let routes = item.routes
                for routeIndex in 0 ... routes.count - 1 {
                    if routeIndex == buttonIndex {
                        return .success(routes[routeIndex])
                    }
                }
                
                if item.tag == endTag {
                     return .success("end")
                 }
            }
        }
        
        return .failure(.noNextChat)
    }
    
    private func returnButtonArray(with chatModel: ChatModel) -> [ResponseButtonModel] {
        var buttonModelArray: [ResponseButtonModel] = []
         let repliesArray = chatModel.replies
         
         for index in 0 ... repliesArray.count - 1 {
             buttonModelArray.append(ResponseButtonModel(buttonIndex: index,
                                                         buttonChatID: chatModel.id,
                                                         buttonText: repliesArray[index]))
         }
         
         return buttonModelArray
     }
}
