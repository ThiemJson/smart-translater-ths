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
    
    private let synth = AVSpeechSynthesizer()
    private let rxTranslateType = BehaviorRelay<TranslateType>.init(value: .toVN)
    
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
    }
    
    private func initTranslater() {
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
            }
        }
        
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
        
        switchView.rx.tap()
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
            print("didPress like")
        }
        
        let blockAction = UIAlertAction(title: "DisLike", style: .destructive) { (action) in
            print("didPress dislike")
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

/**
 com.apple.voice.compact.ar-001.Maged - ar-001 - Majed
 com.apple.voice.compact.bg-BG.Daria - bg-BG - Daria
 com.apple.voice.compact.ca-ES.Montserrat - ca-ES - Montse
 com.apple.voice.compact.cs-CZ.Zuzana - cs-CZ - Zuzana
 com.apple.voice.compact.da-DK.Sara - da-DK - Sara
 com.apple.eloquence.de-DE.Sandy - de-DE - Sandy
 com.apple.eloquence.de-DE.Shelley - de-DE - Shelley
 com.apple.ttsbundle.siri_Helena_de-DE_compact - de-DE - Helena
 com.apple.eloquence.de-DE.Grandma - de-DE - Grandma
 com.apple.eloquence.de-DE.Grandpa - de-DE - Grandpa
 com.apple.eloquence.de-DE.Eddy - de-DE - Eddy
 com.apple.eloquence.de-DE.Reed - de-DE - Reed
 com.apple.voice.compact.de-DE.Anna - de-DE - Anna
 com.apple.ttsbundle.siri_Martin_de-DE_compact - de-DE - Martin
 com.apple.eloquence.de-DE.Rocko - de-DE - Rocko
 com.apple.eloquence.de-DE.Flo - de-DE - Flo
 com.apple.voice.compact.el-GR.Melina - el-GR - Melina
 com.apple.ttsbundle.siri_Gordon_en-AU_compact - en-AU - Gordon
 com.apple.voice.compact.en-AU.Karen - en-AU - Karen
 com.apple.ttsbundle.siri_Catherine_en-AU_compact - en-AU - Catherine
 com.apple.eloquence.en-GB.Rocko - en-GB - Rocko
 com.apple.eloquence.en-GB.Shelley - en-GB - Shelley
 com.apple.voice.compact.en-GB.Daniel - en-GB - Daniel
 com.apple.ttsbundle.siri_Martha_en-GB_compact - en-GB - Martha
 com.apple.eloquence.en-GB.Grandma - en-GB - Grandma
 com.apple.eloquence.en-GB.Grandpa - en-GB - Grandpa
 com.apple.eloquence.en-GB.Flo - en-GB - Flo
 com.apple.eloquence.en-GB.Eddy - en-GB - Eddy
 com.apple.eloquence.en-GB.Reed - en-GB - Reed
 com.apple.eloquence.en-GB.Sandy - en-GB - Sandy
 com.apple.ttsbundle.siri_Arthur_en-GB_compact - en-GB - Arthur
 com.apple.voice.compact.en-IE.Moira - en-IE - Moira
 com.apple.voice.compact.en-IN.Rishi - en-IN - Rishi
 com.apple.eloquence.en-US.Flo - en-US - Flo
 com.apple.speech.synthesis.voice.Bahh - en-US - Bahh
 com.apple.speech.synthesis.voice.Albert - en-US - Albert
 com.apple.speech.synthesis.voice.Fred - en-US - Fred
 com.apple.speech.synthesis.voice.Hysterical - en-US - Jester
 com.apple.speech.synthesis.voice.Organ - en-US - Organ
 com.apple.speech.synthesis.voice.Cellos - en-US - Cellos
 com.apple.speech.synthesis.voice.Zarvox - en-US - Zarvox
 com.apple.eloquence.en-US.Rocko - en-US - Rocko
 com.apple.eloquence.en-US.Shelley - en-US - Shelley
 com.apple.speech.synthesis.voice.Princess - en-US - Superstar
 com.apple.eloquence.en-US.Grandma - en-US - Grandma
 com.apple.eloquence.en-US.Eddy - en-US - Eddy
 com.apple.speech.synthesis.voice.Bells - en-US - Bells
 com.apple.eloquence.en-US.Grandpa - en-US - Grandpa
 com.apple.speech.synthesis.voice.Trinoids - en-US - Trinoids
 com.apple.speech.synthesis.voice.Kathy - en-US - Kathy
 com.apple.eloquence.en-US.Reed - en-US - Reed
 com.apple.speech.synthesis.voice.Boing - en-US - Boing
 com.apple.speech.synthesis.voice.Whisper - en-US - Whisper
 com.apple.speech.synthesis.voice.GoodNews - en-US - Good News
 com.apple.speech.synthesis.voice.Deranged - en-US - Wobble
 com.apple.ttsbundle.siri_Nicky_en-US_compact - en-US - Nicky
 com.apple.speech.synthesis.voice.BadNews - en-US - Bad News
 com.apple.ttsbundle.siri_Aaron_en-US_compact - en-US - Aaron
 com.apple.speech.synthesis.voice.Bubbles - en-US - Bubbles
 com.apple.voice.compact.en-US.Samantha - en-US - Samantha
 com.apple.eloquence.en-US.Sandy - en-US - Sandy
 com.apple.speech.synthesis.voice.Junior - en-US - Junior
 com.apple.speech.synthesis.voice.Ralph - en-US - Ralph
 com.apple.voice.compact.en-ZA.Tessa - en-ZA - Tessa
 com.apple.eloquence.es-ES.Shelley - es-ES - Shelley
 com.apple.eloquence.es-ES.Grandma - es-ES - Grandma
 com.apple.eloquence.es-ES.Rocko - es-ES - Rocko
 com.apple.eloquence.es-ES.Grandpa - es-ES - Grandpa
 com.apple.eloquence.es-ES.Sandy - es-ES - Sandy
 com.apple.eloquence.es-ES.Flo - es-ES - Flo
 com.apple.voice.compact.es-ES.Monica - es-ES - Mónica
 com.apple.eloquence.es-ES.Eddy - es-ES - Eddy
 com.apple.eloquence.es-ES.Reed - es-ES - Reed
 com.apple.eloquence.es-MX.Rocko - es-MX - Rocko
 com.apple.voice.compact.es-MX.Paulina - es-MX - Paulina
 com.apple.eloquence.es-MX.Flo - es-MX - Flo
 com.apple.eloquence.es-MX.Sandy - es-MX - Sandy
 com.apple.eloquence.es-MX.Eddy - es-MX - Eddy
 com.apple.eloquence.es-MX.Shelley - es-MX - Shelley
 com.apple.eloquence.es-MX.Grandma - es-MX - Grandma
 com.apple.eloquence.es-MX.Reed - es-MX - Reed
 com.apple.eloquence.es-MX.Grandpa - es-MX - Grandpa
 com.apple.eloquence.fi-FI.Shelley - fi-FI - Shelley
 com.apple.eloquence.fi-FI.Grandma - fi-FI - Grandma
 com.apple.eloquence.fi-FI.Grandpa - fi-FI - Grandpa
 com.apple.eloquence.fi-FI.Sandy - fi-FI - Sandy
 com.apple.voice.compact.fi-FI.Satu - fi-FI - Satu
 com.apple.eloquence.fi-FI.Eddy - fi-FI - Eddy
 com.apple.eloquence.fi-FI.Rocko - fi-FI - Rocko
 com.apple.eloquence.fi-FI.Reed - fi-FI - Reed
 com.apple.eloquence.fi-FI.Flo - fi-FI - Flo
 com.apple.eloquence.fr-CA.Shelley - fr-CA - Shelley
 com.apple.eloquence.fr-CA.Grandma - fr-CA - Grandma
 com.apple.eloquence.fr-CA.Grandpa - fr-CA - Grandpa
 com.apple.eloquence.fr-CA.Rocko - fr-CA - Rocko
 com.apple.eloquence.fr-CA.Eddy - fr-CA - Eddy
 com.apple.eloquence.fr-CA.Reed - fr-CA - Reed
 com.apple.voice.compact.fr-CA.Amelie - fr-CA - Amélie
 com.apple.eloquence.fr-CA.Flo - fr-CA - Flo
 com.apple.eloquence.fr-CA.Sandy - fr-CA - Sandy
 com.apple.eloquence.fr-FR.Grandma - fr-FR - Grandma
 com.apple.eloquence.fr-FR.Flo - fr-FR - Flo
 com.apple.eloquence.fr-FR.Rocko - fr-FR - Rocko
 com.apple.eloquence.fr-FR.Grandpa - fr-FR - Grandpa
 com.apple.eloquence.fr-FR.Sandy - fr-FR - Sandy
 com.apple.eloquence.fr-FR.Eddy - fr-FR - Eddy
 com.apple.ttsbundle.siri_Daniel_fr-FR_compact - fr-FR - Daniel
 com.apple.voice.compact.fr-FR.Thomas - fr-FR - Thomas
 com.apple.eloquence.fr-FR.Jacques - fr-FR - Jacques
 com.apple.ttsbundle.siri_Marie_fr-FR_compact - fr-FR - Marie
 com.apple.eloquence.fr-FR.Shelley - fr-FR - Shelley
 com.apple.voice.compact.he-IL.Carmit - he-IL - Carmit
 com.apple.voice.compact.hi-IN.Lekha - hi-IN - Lekha
 com.apple.voice.compact.hr-HR.Lana - hr-HR - Lana
 com.apple.voice.compact.hu-HU.Mariska - hu-HU - Tünde
 com.apple.voice.compact.id-ID.Damayanti - id-ID - Damayanti
 com.apple.eloquence.it-IT.Eddy - it-IT - Eddy
 com.apple.eloquence.it-IT.Sandy - it-IT - Sandy
 com.apple.eloquence.it-IT.Reed - it-IT - Reed
 com.apple.eloquence.it-IT.Shelley - it-IT - Shelley
 com.apple.eloquence.it-IT.Grandma - it-IT - Grandma
 com.apple.eloquence.it-IT.Grandpa - it-IT - Grandpa
 com.apple.eloquence.it-IT.Flo - it-IT - Flo
 com.apple.eloquence.it-IT.Rocko - it-IT - Rocko
 com.apple.voice.compact.it-IT.Alice - it-IT - Alice
 com.apple.eloquence.ja-JP.Eddy - ja-JP - Eddy
 com.apple.ttsbundle.siri_O-ren_ja-JP_compact - ja-JP - O-ren
 com.apple.eloquence.ja-JP.Reed - ja-JP - Reed
 com.apple.eloquence.ja-JP.Shelley - ja-JP - Shelley
 com.apple.voice.compact.ja-JP.Kyoko - ja-JP - Kyoko
 com.apple.eloquence.ja-JP.Grandma - ja-JP - Grandma
 com.apple.eloquence.ja-JP.Rocko - ja-JP - Rocko
 com.apple.eloquence.ja-JP.Grandpa - ja-JP - Grandpa
 com.apple.ttsbundle.siri_Hattori_ja-JP_compact - ja-JP - Hattori
 com.apple.eloquence.ja-JP.Sandy - ja-JP - Sandy
 com.apple.eloquence.ja-JP.Flo - ja-JP - Flo
 com.apple.eloquence.ko-KR.Rocko - ko-KR - Rocko
 com.apple.eloquence.ko-KR.Grandma - ko-KR - Grandma
 com.apple.eloquence.ko-KR.Grandpa - ko-KR - Grandpa
 com.apple.eloquence.ko-KR.Eddy - ko-KR - Eddy
 com.apple.eloquence.ko-KR.Sandy - ko-KR - Sandy
 com.apple.voice.compact.ko-KR.Yuna - ko-KR - Yuna
 com.apple.eloquence.ko-KR.Reed - ko-KR - Reed
 com.apple.eloquence.ko-KR.Flo - ko-KR - Flo
 com.apple.eloquence.ko-KR.Shelley - ko-KR - Shelley
 com.apple.voice.compact.ms-MY.Amira - ms-MY - Amira
 com.apple.voice.compact.nb-NO.Nora - nb-NO - Nora
 com.apple.voice.compact.nl-BE.Ellen - nl-BE - Ellen
 com.apple.voice.compact.nl-NL.Xander - nl-NL - Xander
 com.apple.voice.compact.pl-PL.Zosia - pl-PL - Zosia
 com.apple.eloquence.pt-BR.Reed - pt-BR - Reed
 com.apple.voice.compact.pt-BR.Luciana - pt-BR - Luciana
 com.apple.eloquence.pt-BR.Shelley - pt-BR - Shelley
 com.apple.eloquence.pt-BR.Grandma - pt-BR - Grandma
 com.apple.eloquence.pt-BR.Grandpa - pt-BR - Grandpa
 com.apple.eloquence.pt-BR.Rocko - pt-BR - Rocko
 com.apple.eloquence.pt-BR.Flo - pt-BR - Flo
 com.apple.eloquence.pt-BR.Sandy - pt-BR - Sandy
 com.apple.eloquence.pt-BR.Eddy - pt-BR - Eddy
 com.apple.voice.compact.pt-PT.Joana - pt-PT - Joana
 com.apple.voice.compact.ro-RO.Ioana - ro-RO - Ioana
 com.apple.voice.compact.ru-RU.Milena - ru-RU - Milena
 com.apple.voice.compact.sk-SK.Laura - sk-SK - Laura
 com.apple.voice.compact.sl-SI.Tina - sl-SI - Tina
 com.apple.voice.compact.sv-SE.Alva - sv-SE - Alva
 com.apple.voice.compact.th-TH.Kanya - th-TH - Kanya
 com.apple.voice.compact.tr-TR.Yelda - tr-TR - Yelda
 com.apple.voice.compact.uk-UA.Lesya - uk-UA - Lesya
 com.apple.voice.compact.vi-VN.Linh - vi-VN - Linh
 com.apple.eloquence.zh-CN.Eddy - zh-CN - Eddy
 com.apple.eloquence.zh-CN.Shelley - zh-CN - Shelley
 com.apple.ttsbundle.siri_Li-mu_zh-CN_compact - zh-CN - Li-mu
 com.apple.eloquence.zh-CN.Grandma - zh-CN - Grandma
 com.apple.eloquence.zh-CN.Reed - zh-CN - Reed
 com.apple.eloquence.zh-CN.Grandpa - zh-CN - Grandpa
 com.apple.eloquence.zh-CN.Rocko - zh-CN - Rocko
 com.apple.eloquence.zh-CN.Flo - zh-CN - Flo
 com.apple.voice.compact.zh-CN.Tingting - zh-CN - Tingting
 com.apple.ttsbundle.siri_Yu-shu_zh-CN_compact - zh-CN - Yu-shu
 com.apple.eloquence.zh-CN.Sandy - zh-CN - Sandy
 com.apple.voice.compact.zh-HK.Sinji - zh-HK - Sinji
 com.apple.eloquence.zh-TW.Shelley - zh-TW - Shelley
 com.apple.eloquence.zh-TW.Grandma - zh-TW - Grandma
 com.apple.eloquence.zh-TW.Grandpa - zh-TW - Grandpa
 com.apple.eloquence.zh-TW.Sandy - zh-TW - Sandy
 com.apple.eloquence.zh-TW.Flo - zh-TW - Flo
 com.apple.eloquence.zh-TW.Eddy - zh-TW - Eddy
 com.apple.eloquence.zh-TW.Reed - zh-TW - Reed
 com.apple.voice.compact.zh-TW.Meijia - zh-TW - Meijia
 com.apple.eloquence.zh-TW.Rocko - zh-TW - Rocko*/
