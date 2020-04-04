//
//  ResponseButtonView.swift
//  ChatRobot
//
//  Created by 李祺 on 04/04/2020.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class ResponseButtonView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func createButtonView() -> UIButton {
//        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        customView.backgroundColor = UIColor.red
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        button.setTitle("Submit", for: .normal)
////        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        customView.addSubview(button)
//    }
    
}
