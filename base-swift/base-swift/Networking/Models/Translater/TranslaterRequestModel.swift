//
//  TranslaterRequestModel.swift
//  smart-translater
//
//  Created by Thiem Nguyen Cao (SDC11) on 7/2/25.
//  Copyright © 2025 BaseSwift. All rights reserved.
//

import Foundation

struct TranslaterRequestModel : Codable {
    var translate: String?
    var fromlangue: String?
    var tolangue: String?
    var field: String?
    var topic: String?
    
    enum CodingKeys: String, CodingKey {
        case translate = "translate"
        case fromlangue = "fromlangue"
        case tolangue = "tolangue"
        case field = "field"
        case topic = "topic"
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        translate = try values.decodeIfPresent(String.self, forKey: .translate)
        fromlangue = try values.decodeIfPresent(String.self, forKey: .fromlangue)
        tolangue = try values.decodeIfPresent(String.self, forKey: .tolangue)
        field = try values.decodeIfPresent(String.self, forKey: .field)
        topic = try values.decodeIfPresent(String.self, forKey: .topic)
    }
    
    mutating func toJSON() -> [String: Any] {
        return self.convertObjectToJson()?.dictionaryObject ?? [:]
    }
}

struct LikeUnLikeRequestModel : Codable {
    var idRequest: String?
    var likeorunlike: Int?
    
    enum CodingKeys: String, CodingKey {
        case idRequest = "id_request"
        case likeorunlike = "likeorunlike"
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idRequest = try values.decodeIfPresent(String.self, forKey: .idRequest)
        likeorunlike = try values.decodeIfPresent(Int.self, forKey: .likeorunlike)
    }
    
    mutating func toJSON() -> [String: Any] {
        return self.convertObjectToJson()?.dictionaryObject ?? [:]
    }
}
