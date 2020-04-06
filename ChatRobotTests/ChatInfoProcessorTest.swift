//
//  ChatInfoProcessorTest.swift
//  ChatRobotTests
//
//  Created by 李祺 on 04/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import XCTest
@testable import ChatRobot

class ChatInfoProcessorTest: XCTestCase {
    
    func testFindStartChatWithStart() {
        // given
        let chatData = DataGenerator()
        chatData.finishFetchChatData()
        let chatInfoProcessor = ChatInfoProcessor.init(chatScheme: chatData.completeChatData!)
        
        // when
        let chatHistoryModel = try! chatInfoProcessor.findStartChat().get()
        
        // assert
        XCTAssertEqual(chatHistoryModel.contentText, "Want to do a quick word game?")
        XCTAssertEqual(chatHistoryModel.buttons[0].buttonChatID,chatData.completeChatData![0].id)
    }
    
    func testFindStartChatWithoutStart() {
        
        // given
        let chatData = DataGenerator()
        chatData.finishFetchChatData()
        
        // when
        let chatInfoProcessor = ChatInfoProcessor.init(chatScheme: chatData.chatWithoutStart!)
        
        //assert
        XCTAssertThrowsError(try chatInfoProcessor.findStartChat().get()) { error in
            
            XCTAssertEqual(error as! ChatServiceError, ChatServiceError.noStartChat)
        }
    }
    
    func testChatModelWithoutNext(){
        
        // given
        let chatData = DataGenerator()
        chatData.finishFetchChatData()
        // when
        let chatInfoProcessor = ChatInfoProcessor.init(chatScheme: chatData.chatWithoutEnd!)
        //assert
        XCTAssertThrowsError(try chatInfoProcessor.findNextChat(withID: "YMB", andIndex: 20).get()) { error in
            
            XCTAssertEqual(error as! ChatServiceError, ChatServiceError.noNextChat)
        }
    }
    
    func testChatModelWithEnd() {
        
        // given
        let chatData = DataGenerator()
        chatData.finishFetchChatData()
        let chatInfoProcessor = ChatInfoProcessor(chatScheme: chatData.completeChatData!)
        // when
        let chatHistoryModel = try! chatInfoProcessor.findNextChat(withID: "YMB", andIndex: 20).get()
        //assert
        XCTAssertEqual(chatHistoryModel.contentText, "end")
    }
}
