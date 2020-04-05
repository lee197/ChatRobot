//
//  DataSourceService.swift
//  ChatRobot
//
//  Created by 李祺 on 03/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

enum ChatServiceError: String, Error {
    case noStartChat
    case noEndChat
    case serverError
    case noNextChat
}

protocol DatasourceProtocol {
    func  getChatGuide(complete completionHandler: @escaping (Result<[ChatModel],ChatServiceError>) -> ())
}

class DatasourceService: DatasourceProtocol {
    
    let fileName = "allornothing"
    
    func getChatGuide(complete completionHandler: @escaping (Result<[ChatModel],ChatServiceError>) -> ()) {
        
        DispatchQueue.global().async { [weak self] in
            do {
                let path = Bundle.main.path(forResource: self?.fileName, ofType: "json")!
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let chatSchme = try decoder.decode([ChatModel].self, from: data)
                completionHandler(.success(chatSchme))
            } catch  {
                completionHandler(.failure(.serverError))
            }
        }
        
        
    }
}

