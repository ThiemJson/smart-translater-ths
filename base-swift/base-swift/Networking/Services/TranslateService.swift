//
//  TranslateService.swift
//  smart-translater
//
//  Created by Thiem Nguyen Cao (SDC11) on 7/2/25.
//  Copyright © 2025 BaseSwift. All rights reserved.
//

import Foundation

public class TranslateService {
    static func translate(_ model: TranslaterRequestModel) -> BaseResult<TranslaterResponseModel> {
        return BaseRouter.translate(model: model).object()
    }
    static func likeOrUnlike(_ model: LikeUnLikeRequestModel) -> BaseResult<BaseResponse> {
        return BaseRouter.likeofunlike(model: model).object()
    }
}
