//
//  ViewModel.swift
//  ChatRobot
//
//  Created by 李祺 on 03/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

enum UserAlertError:  String, Error {
    case userError = "Please make sure your network is working fine or re-launch the app"
    case serverError = "Please wait a while and re-launch the app"
}

final class ChatViewModel {
    var chatHistoryArray: [ChatHistoryModel] = []
    private let apiClient: DatasourceProtocol
    private var chatProcesser: ChatInfoProcessor?
    private var cellViewModels: [ChatListCellViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    init(apiClient: DatasourceProtocol = DatasourceService()) {
        self.apiClient = apiClient
    }
    
    func initFetch() {
        apiClient.getChatGuide { [weak self] result in
            do {
                let chatData = try result.get()
                self?.processChatInfo(chatInfo: chatData)
            } catch {
                self?.alertMessage = UserAlertError.serverError.rawValue
            }
        }
    }
    
    func getCellModels(at indexPath: IndexPath) -> ChatListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func getButtonGroup() -> [ResponseButtonModel] {
        if let buttonModels = chatHistoryArray.last?.buttons{
            return buttonModels
        } else {
            return []
        }
    }
    
    func getNumberOfRows() -> Int {
        return chatHistoryArray.count
    }
    
    private func processChatInfo(chatInfo: [ChatModel]) {
        chatProcesser = ChatInfoProcessor(chatScheme: chatInfo)
        guard let chatProcesser = chatProcesser else {
            return
        }
        
        do {
            let stratChat = try chatProcesser.findStartChat().get()
            chatHistoryArray.append(stratChat)
        } catch {
            alertMessage = UserAlertError.serverError.rawValue
        }
        
        self.cellViewModels = createCellModels(chatObjects: chatHistoryArray)
    }
    
    private func createCellModels(chatObjects: [ChatHistoryModel]) -> [ChatListCellViewModel] {
        return chatObjects.map { ChatListCellViewModel(contentText: $0.contentText, isRobot: $0.isRobot) }
    }
}

extension ChatViewModel {
    
    func userPressedButton(buttonModel: ResponseButtonModel) {
        chatHistoryArray.append(ChatHistoryModel(contentText: buttonModel.buttonText,
                                                      isRobot: false,
                                                      buttons: []))
        
        guard let chatProcesser = chatProcesser else {
            return
        }
        
        do {
            let nextChat = try chatProcesser.findNextChat(withID: buttonModel.buttonChatID,
                                                          andIndex: buttonModel.buttonIndex).get()
            self.chatHistoryArray.append(nextChat)
            self.cellViewModels = createCellModels(chatObjects: chatHistoryArray)
        } catch {
            alertMessage = UserAlertError.serverError.rawValue
        }
    }
}

struct ChatListCellViewModel {
    let contentText: String
    var isRobot: Bool
}


