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
    private lazy var buttonModels: [ResponseButtonModel] = {
        return []
    }()
    private weak var tableView: UITableView!
    private weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColorScheme.themeColor
        self.view.addSubview(tableView)
        tableView.setContentHuggingPriority(UILayoutPriority(rawValue: 200), for: .vertical)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor,constant: 150),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
        self.tableView = tableView
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: self.view.frame.width/2 - 20, height: 44)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        self.collectionView = collectionView
    }
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ChatButtonCell.self, forCellWithReuseIdentifier: ChatButtonCell.identifier)
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = AppColorScheme.themeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColorScheme.themeColor
        self.navigationItem.title = "All or Nothing"
        setupTableView()
        initViewModel()
        setupCollectionView()
    }
    
    private func initViewModel() {
        chatViewModel.showAlertClosure = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.showAlert(alertMessage: self.chatViewModel.alertMessage ?? "UNKOWN ERROR")
            }
        }
        
        chatViewModel.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(item: (self.chatViewModel.chatHistoryArray.count) - 1, section: 0), at: .bottom, animated: true)
                self.buttonModels = self.chatViewModel.getButtonGroup()
            }
        }
        
        chatViewModel.initFetch()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UserChatCell.self, forCellReuseIdentifier: "chatUserCell")
        tableView.register(RobotChatCell.self, forCellReuseIdentifier: "chatRobotCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
    }
    
    private func showAlert(alertMessage:String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatViewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = chatViewModel.getCellModels(at: indexPath)
        if item.isRobot {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatRobotCell") as! RobotChatCell
            cell.chatCellViewModel = item
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatUserCell") as! UserChatCell
            cell.chatCellViewModel = item
            return cell
        }
    }
}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return buttonModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatButtonCell.identifier, for: indexPath) as! ChatButtonCell
        cell.textLabel.text = buttonModels[indexPath.item].buttonText
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.chatViewModel.userPressedButton(buttonModel: buttonModels[indexPath.row])
    }
}

enum AppColorScheme {
    static let themeColor = UIColor(red: 0, green: 33/255, blue: 51/255, alpha: 1.0)
    static let robotChatColor = UIColor(red: 0, green: 83/255, blue: 128/255, alpha: 1.0)
    static let userChatColor = UIColor(red: 0, green: 128/255, blue: 0/255, alpha: 1.0)
    static let navColor = UIColor(red: 0, green: 99/255, blue: 153/255, alpha: 1.0)
}
