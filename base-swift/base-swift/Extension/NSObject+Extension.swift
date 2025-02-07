//  NSObject+Extension.swift
//  BaseSwift
//
//  Created by Atula on 7/10/20.
//  Copyright © 2023 BaseProject. All rights reserved.
//

import Foundation
extension NSObject {
    
    func log(_ message: String, _ funcName: String = #function) {
        #if DEBUG
            print("debugLog >>> \(NSStringFromClass(self.classForCoder)) >>> \(funcName) >>> \(message)")
        #endif
    }
    
}

import UIKit

extension NSObject {
    static var name: String {
        return String(describing: self)
    }
    // For Instance of class get name
    var className: String {
        return String(describing: type(of: self))
    }
    
    static var getNib: UINib {
        return UINib(nibName: self.name, bundle: nil)
    }
}

class DeepCopier {
    static func copy<T: Codable>(of object: T) -> T {
        do {
            let json = try JSONEncoder().encode(object)
            return try JSONDecoder().decode(T.self, from: json)
        } catch {
            return object
        }
    }
}
