//
//  TranslaterResponseModel.swift
//  smart-translater
//
//  Created by Thiem Nguyen Cao (SDC11) on 7/2/25.
//  Copyright © 2025 BaseSwift. All rights reserved.
//

import Foundation

struct TranslaterResponseModel : Codable {
    var response: String?
    var idRequest: String?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
        case idRequest = "id_request"
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decodeIfPresent(String.self, forKey: .response)
        idRequest = try values.decodeIfPresent(String.self, forKey: .idRequest)
    }
    
    mutating func toJSON() -> [String: Any] {
        return self.convertObjectToJson()?.dictionaryObject ?? [:]
    }
}
