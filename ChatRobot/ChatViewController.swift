//
//  ViewController.swift
//  ChatRobot
//
//  Created by 李祺 on 03/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private lazy var chatViewModel = {
        return ChatViewModel()
    }()
    private var buttonModels = {
       return [ResponseButtonModel]()
    }()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: UIScreen.main.bounds.height - 80))
        tableView.backgroundColor = .darkGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        self.view.backgroundColor = .darkGray
        setupTableView()
        initViewModel()
    }
    
    func createChatView() {
        
        let chatView = UIView(frame: CGRect(x: 0,
                                              y: UIScreen.main.bounds.height - 80,
                                              width: UIScreen.main.bounds.width,
                                              height: 80))
        chatView.backgroundColor = UIColor.lightGray
        
        self.buttonModels = self.chatViewModel.getButtonGroup()
        
        for i in 0 ... buttonModels.count - 1 {
            
            let button = UIButton(frame: CGRect(x: 20 + i*60, y: 0, width: 60, height: 50))
            button.setTitle(buttonModels[i].buttonText, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.tag = i
            chatView.addSubview(button)
        }
        
        self.view.addSubview(chatView)
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        self.chatViewModel.userPressedButton(buttonModel: buttonModels[sender.tag])
    }
    
    private func initViewModel() {
        
        chatViewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.showAlert(alertMessage: self?.chatViewModel.alertMessage ?? "UNKOWN ERROR")
            }
        }
        
        chatViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.createChatView()
            }
        }
        
        chatViewModel.initFetch()
    }
    
    private func setupTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "chatCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    private func showAlert(alertMessage:String){
        
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatViewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatListCell
        cell.chatCellViewModel = chatViewModel.getCellModels(at: indexPath)
        return cell
    }
    
}
