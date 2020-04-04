//
//  ChatRobotTests.swift
//  ChatRobotTests
//
//  Created by 李祺 on 03/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import XCTest
@testable import ChatRobot

class ChatViewModelTests: XCTestCase {
    
    var sut:ChatViewModel!
    var mockService: MockDataSourceService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockService = MockDataSourceService()
        sut = ChatViewModel(apiClient: mockService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockService = nil
        sut = nil
    }
    
    func testIfFetchGetCalled(){
        sut.initFetch()
        XCTAssert(mockService.isFetchDataCalled)
    }
    
    func testFetchFailed(){
        let userError = UserAlertError.serverError
        let error = ChatServiceError.noEndChat
        
        sut.initFetch()
        mockService.fetchFail(error: error)
        
        XCTAssertEqual(sut.alertMessage, userError.rawValue)
    }
    
    func testGetCellModelsAtStart(){
        
        // given
        goToFetchFinish()
        let indexPath = IndexPath(row: 0, section: 0)
        let testChatData = mockService.completeChatData[indexPath.row]
        
        // when
        let vm = sut.getCellModels(at: indexPath)
        
        // assert
        XCTAssertEqual(vm.contentText, testChatData.text)
    }
    
    func testGetButtonsGroupAtStart() {
        // given
        goToFetchFinish()
        let testChatData = mockService.completeChatData[0]
        
        //when
        let buttonGroup = sut.getButtonGroup()
        
        // assert
        XCTAssertEqual(buttonGroup.count, testChatData.replies.count)
    }
    
    func testUserPressedFirstButtonInFristQuestion() {
        
        goToFetchFinish()
        let startIndex = 0
        let userChoosedIndex = 0
        let startChatModel = mockService.completeChatData[startIndex]
        
        let buttonModel = ResponseButtonModel(buttonIndex: startIndex,
                                              buttonChatID: startChatModel.id,
                                              buttonText: startChatModel.replies[userChoosedIndex])
        
        sut.userPressedButton(buttonModel: buttonModel)
        let lastIndex = sut.chatHistoryArray.endIndex - 1
        
        XCTAssertEqual(sut.chatHistoryArray[lastIndex - 1].contentText, buttonModel.buttonText)
    }
    
    func testRobotResponseAfterUserPressedFirstButton() {
        
        goToFetchFinish()
        let startIndex = 0
        let userChoosedIndex = 0
        let startChatModel = mockService.completeChatData[startIndex]
        
        let buttonModel = ResponseButtonModel(buttonIndex: startIndex,
                                              buttonChatID: startChatModel.id,
                                              buttonText: startChatModel.replies[userChoosedIndex])
        let testRoute = mockService.completeChatData[startIndex].routes[userChoosedIndex]
        let testData = mockService.completeChatData.filter{ $0.id == testRoute }[0]
        
        sut.userPressedButton(buttonModel: buttonModel)
        let lastIndex = sut.chatHistoryArray.endIndex - 1
        
        XCTAssertEqual(sut.chatHistoryArray[lastIndex].contentText, testData.text)
    }
    
}

extension ChatViewModelTests {
    
    private func goToFetchFinish(){
        let chatData = DataGenerator()
        chatData.finishFetchChatData()
        mockService.completeChatData = chatData.completeChatData!
        sut.initFetch()
        mockService.fetchSuccess()
    }
}
