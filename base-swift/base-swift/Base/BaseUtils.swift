//
//  BaseUtils.swift
//  base-swift
//
//  Created by ThiemJason on 24/04/2023.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

// MARK: - Screen
struct BaseUtils {
    static var safeInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    static var topInset: CGFloat {
        return safeInsets.top
    }
    
    static var bottomInset: CGFloat {
        return safeInsets.bottom
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isSmallScreen: Bool {
        return screenWidth < 375
    }
    
    static var viewScale: CGFloat {
        if !isSmallScreen { return 1 }
        return screenWidth / 375
    }
}

// MARK: - Settings
extension BaseUtils {
    static func openWifiSettings() {
        guard let url = URL(string:"App-prefs:WIFI"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


struct Fonts {
    
}

extension Fonts {
    static func hiraKakuW3(size: CGFloat) -> UIFont {
        let uiFont = UIFont(name: "HiraginoSans-W3", size: size) ?? .systemFont(ofSize: size,
                                                                               weight: .regular)
        return uiFont
    }
    
    static func hiraKakuW4(size: CGFloat) -> UIFont {
        let uiFont = UIFont(name: "HiraginoSans-W4", size: size) ?? .systemFont(ofSize: size,
                                                                               weight: .regular)
        return uiFont
    }
    
    static func hiraKakuW7(size: CGFloat) -> UIFont {
        let uiFont = UIFont(name: "HiraginoSans-W7", size: size) ?? .systemFont(ofSize: size,
                                                                               weight: .bold)
        return uiFont
    }
    
    static func hiraKakuW6(size: CGFloat) -> UIFont {
        let uiFont = UIFont(name: "HiraginoSans-W6", size: size) ?? .systemFont(ofSize: size,
                                                                               weight: .semibold)
        return uiFont
    }
    
    static func hiraKakuW5(size: CGFloat) -> UIFont {
        let uiFont = UIFont(name: "HiraginoSans-W5", size: size) ?? .systemFont(ofSize: size,
                                                                               weight: .semibold)
        return uiFont
    }
}
