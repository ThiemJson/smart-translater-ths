//
//  TranslateCell.swift
//  base-swift
//
//  Created by Thiem Nguyen Cao (SDC11) on 4/2/25.
//  Copyright © 2025 BaseSwift. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum TranslateCellAction {
    case speaker
    case copy
    case reation
    case more
    case didChangeInput(_ text: String)
    case didChangeHeight
}

enum TranslateSupportLn {
    case vn
    case en
    
    var name: String {
        switch self {
        case .en:
            return "English"
        case .vn:
            return "Vietnamese"
        }
    }
    
    var locale: String {
        switch self {
        case .en:
            return "en-US"
        case .vn:
            return "vi-VN"
        }
    }
}

enum TranslateCellType {
    case from
    case to
    
    var color: UIColor {
        switch self {
        case .from:
            return .black
        case .to:
            return .primary
        }
    }
    
    var copyable: Bool {
        switch self {
        case .from:
            return false
        case .to:
            return true
        }
    }
    
    var reactionable: Bool {
        switch self {
        case .from:
            return false
        case .to:
            return true
        }
    }
    
    var extendable: Bool {
        switch self {
        case .from:
            return false
        case .to:
            return true
        }
    }
    
    var placeholder: String {
        switch self {
        case .from:
            return "Enter text ..."
        case .to:
            return ""
        }
    }
}

class TranslateCell: BaseNibView {
    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var textInput: GrowingTextView!
    @IBOutlet weak var speakerBtn: UIImageView!
    @IBOutlet weak var copyBtn: UIImageView!
    @IBOutlet weak var reactionBtn: UIImageView!
    @IBOutlet weak var moreBtn: UIImageView!
    @IBOutlet weak var inputHeightCons: NSLayoutConstraint!
    
    public let rxType = BehaviorRelay<TranslateCellType>.init(value: .from)
    public let rxLangague = BehaviorRelay<TranslateSupportLn>.init(value: .en)
    
    public var actionHandler: ((TranslateCellAction) -> Void)?
    
    override func commonInit() {
        super.commonInit()
        initView()
        byViewModel()
        updateHeight()
    }
}

extension TranslateCell {
    public func refresh() {
        textInput.text = ""
    }
    
    private func initView() {
        textInput.textAlignment = .left
        textInput.delegate = self
        textInput.isScrollEnabled = true
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        let color = UIColor.black.withAlphaComponent(0.8)
        let font = Fonts.hiraKakuW6(size: 16)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        let attributed = [NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.font: font,
                          NSAttributedString.Key.paragraphStyle: style]
        let placeholder = NSAttributedString(string:  rxType.value.placeholder,
                                             attributes: attributed)
        textInput.attributedPlaceholder = placeholder
    }
    
    private func byViewModel() {
        rxType
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] type in
                guard let `self` = self else { return }
                // Hiddenable
                copyBtn.isHidden = !type.copyable
                reactionBtn.isHidden = !type.reactionable
                moreBtn.isHidden = !type.extendable
                // Color
                languageTitle.textColor = type.color.withAlphaComponent(0.7)
                textInput.textColor = type.color
                speakerBtn.tintColor = type.color
                reactionBtn.tintColor = type.color
                copyBtn.tintColor = type.color
                moreBtn.tintColor = type.color
                // Text input
                textInput.text = ""
                // Editable
                textInput.isEditable = type == .from
                // Placeholder
                updatePlaceholder()
            }.disposed(by: disposables)
        
        rxLangague.map { $0.name }.bind(to: languageTitle.rx.text).disposed(by: disposables)
        
        speakerBtn.rx.tap()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                actionHandler?(.speaker)
            }.disposed(by: disposables)
        
        copyBtn.rx.tap()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                actionHandler?(.copy)
            }.disposed(by: disposables)
        
        reactionBtn.rx.tap()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                actionHandler?(.reation)
            }.disposed(by: disposables)
        
        moreBtn.rx.tap()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                actionHandler?(.more)
            }.disposed(by: disposables)
    }
}


extension TranslateCell: GrowingTextViewDelegate {
    @discardableResult
    public func updateHeight() -> CGFloat {
        // Update height
        let size = textInput.sizeThatFits(
            CGSize(width: textInput.bounds.size.width,
                   height: CGFloat.greatestFiniteMagnitude)
        )
        inputHeightCons.constant = size.height
        return size.height
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateHeight()
        actionHandler?(.didChangeInput(textView.text))
        actionHandler?(.didChangeHeight)
    }
}
