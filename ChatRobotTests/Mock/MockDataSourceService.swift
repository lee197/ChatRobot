//
//  MockDataSourceService.swift
//  ChatRobotTests
//
//  Created by 李祺 on 04/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
@testable import ChatRobot

class MockDataSourceService {
    var isFetchDataCalled = false
    var completeChatData: [ChatModel] = []
    var completeClosure: ((Result<[ChatModel], ChatServiceError>) -> Void)!
    
    func fetchSuccess() {
        completeClosure(.success(completeChatData))
    }
    
    func fetchFail(error: ChatServiceError) {
        completeClosure(.failure(error))
    }
}

extension MockDataSourceService: DatasourceProtocol {
    
    func getChatGuide(complete completionHandler: @escaping (Result<[ChatModel], ChatServiceError>) -> ()) {
        isFetchDataCalled = true
        completeClosure = completionHandler
    }
}

class DataGenerator {
    
    var completeChatData: [ChatModel]?
    var chatWithoutStart: [ChatModel]?
    var chatWithoutEnd: [ChatModel]?
    
    func finishFetchChatData() {
        DatasourceService().getChatGuide { [weak self] result in
            self?.completeChatData = try! result.get()
            self?.mockNoEndData(completData: try! result.get())
            self?.mockNoStartData(completData: try! result.get())
        }
    }
    
    private func mockNoStartData(completData: [ChatModel]) {
        chatWithoutStart = completData
        
        for index in 0 ... completData.count - 1 {
            if chatWithoutStart![index].tag == "allornothing-start" {
                chatWithoutStart![index].tag = ""
            }
        }
    }
    
    private func mockNoEndData(completData: [ChatModel]) {
        chatWithoutEnd = completData
        
        for index in 0 ... completData.count - 1 {
            if chatWithoutEnd![index].tag == "bye" {
                chatWithoutEnd![index].tag = ""
            }
        }
    }
}
