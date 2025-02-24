//
//  ExtendField.swift
//  base-swift
//
//  Created by Thiem Nguyen Cao (SDC11) on 5/2/25.
//  Copyright © 2025 BaseSwift. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum ExtendType {
    case topic
    case field
}

class ExtendField: BaseNibView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    override func commonInit() {
        super.commonInit()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.primary.cgColor
        textField.borderStyle = .none
    }
    
    public func refresh() {
        textField.text = ""
    }
    
    public func setType(_ type: ExtendType) {
        switch type {
        case .field:
            textField.placeholder = "Field ..."
        case .topic:
            textField.placeholder = "Topic ..."
        }
    }
}
