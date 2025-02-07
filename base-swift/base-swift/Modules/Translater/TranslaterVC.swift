//
//  TranslaterVC.swift
//  base-swift
//
//  Created by Thiem Nguyen Cao (SDC11) on 4/2/25.
//  Copyright © 2025 BaseSwift. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD
import Toast_Swift
import AVFoundation

enum TranslateType {
    case toVN
    case toEN
}

class TranslaterVC: BaseViewController {
    @IBOutlet weak var fromView: TranslateCell!
    @IBOutlet weak var toView: TranslateCell!
    @IBOutlet weak var fieldView: ExtendField!
    @IBOutlet weak var topicView: ExtendField!
    @IBOutlet weak var switchView: UIView!
    // switch label
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var translateBtn: UIView!
    @IBOutlet weak var stackSwitchLanguage: UIStackView!
    
    private let synth = AVSpeechSynthesizer()
    private var currentRequest = ""
    private let rxTranslateType = BehaviorRelay<TranslateType>.init(value: .toVN)
    private let rxLoading = BehaviorRelay<Bool>.init(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initTranslater()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fromView.updateHeight()
        toView.updateHeight()
    }
}
    
extension TranslaterVC {
    private func initView() {
        // Type
        fromView.rxType.accept(.from)
        toView.rxType.accept(.to)
        // Language
        fromView.rxLangague.accept(.en)
        toView.rxLangague.accept(.vn)
        // Extend
        fieldView.setType(.field)
        topicView.setType(.topic)
        // Translate
        translateBtn.layer.borderColor = UIColor.primary.cgColor
        translateBtn.layer.borderWidth = 2
    }
    
    private func initTranslater() {
        translateBtn.rx.tap()
            .subscribe { [weak self] _ in
                guard let `self` = self else { return }
                translate()
            }.disposed(by: rxDisposeBag)
        
        fromView.actionHandler = { [weak self] action in
            guard let `self` = self else { return }
            switch action {
            case .copy:
                view.makeToast("Copied to clipboard !")
                UIPasteboard.general.string = fromView.textInput.text
            case .more:
                break
            case .speaker:
                let text = fromView.textInput.text ?? ""
                if text.isEmpty { break }
                playSpeaker(text: text, locale: fromView.rxLangague.value.locale)
            case .reation:
                showRateTranslation()
            case .didChangeInput(_):
                break
            case .didChangeHeight:
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
        
        toView.actionHandler = { [weak self] action in
            guard let `self` = self else { return }
            switch action {
            case .copy:
                view.makeToast("Copied to clipboard !")
                UIPasteboard.general.string = toView.textInput.text
            case .more:
                break
            case .speaker:
                playSpeaker(text: toView.textInput.text, locale: toView.rxLangague.value.locale)
            case .reation:
                showRateTranslation()
            case .didChangeInput(_):
                break
            case .didChangeHeight:
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
        
        rxLoading
            .observe(on: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe { loading in
                if loading {
                    SVProgressHUD.show()
                } else {
                    SVProgressHUD.dismiss()
                }
            }
            .disposed(by: rxDisposeBag)
        
        rxTranslateType
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] type in
                guard let `self` = self else { return }
                switch type {
                case .toVN:
                    fromView.rxLangague.accept(.en)
                    toView.rxLangague.accept(.vn)
                    fromLabel.text = "English"
                    toLabel.text = "Vietnamese"
                case .toEN:
                    fromView.rxLangague.accept(.vn)
                    toView.rxLangague.accept(.en)
                    fromLabel.text = "Vietnamese"
                    toLabel.text = "English"
                }
                fromView.refresh()
                toView.refresh()
            }
            .disposed(by: rxDisposeBag)
        
        stackSwitchLanguage.rx.tap()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.switchLanguage()
            }.disposed(by: rxDisposeBag)
    }
    
    private func refreshAll() {
        fromView.refresh()
        toView.refresh()
        fieldView.refresh()
        topicView.refresh()
    }
    
    private func switchLanguage() {
        refreshAll()
        let current = rxTranslateType.value
        rxTranslateType.accept(current == .toEN ? .toVN : .toEN)
    }
}

extension TranslaterVC {
    private func playSpeaker(text: String, locale: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: locale)
        synth.speak(utterance)
    }
    
    private func showRateTranslation() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Like", style: .default) { (action) in
            self.likeOrUnlike(isLike: true)
        }
        
        let blockAction = UIAlertAction(title: "Not like", style: .destructive) { (action) in
            self.likeOrUnlike(isLike: false)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("didPress cancel")
        }
        
        actionSheet.addAction(reportAction)
        actionSheet.addAction(blockAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension TranslaterVC {
    private func translate() {
        let input = fromView.textInput.text ?? ""
        if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
        
        self.rxLoading.accept(true)
        var model = TranslaterRequestModel()
        model.fromlangue = fromView.rxLangague.value.name
        model.tolangue = toView.rxLangague.value.name
        model.translate = fromView.textInput.text
        
        let field = fieldView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        model.field = field.isEmpty ? "general" : field
        
        let topic = topicView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        model.topic = topic.isEmpty ? "general" : topic
        
        TranslateService.translate(model)
            .onCompleted {
                self.rxLoading.accept(false)
            }
            .onSuccess { response in
                DispatchQueue.main.async {
                    self.toView.textInput.text = response.response
                    self.currentRequest = response.idRequest ?? ""
                }
            }
            .onError { baseResponse in
                DispatchQueue.main.async {
                    self.view.makeToast("Something went wrong, please try again !")
                }
            }
    }
    
    private func likeOrUnlike(isLike: Bool) {
        self.rxLoading.accept(true)
        var model = LikeUnLikeRequestModel()
        model.idRequest = currentRequest
        model.likeorunlike = isLike ? 1 : 0
        
        TranslateService.likeOrUnlike(model)
            .onCompleted {
                DispatchQueue.main.async {
                    self.rxLoading.accept(false)
                    self.view.makeToast("Thanks for your contribution !")
                }
            }
    }
}
