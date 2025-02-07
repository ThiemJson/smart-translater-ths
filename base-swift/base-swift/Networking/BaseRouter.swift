//
//  OHRouter.swift
//  BaseSwift
//
//  Created by ThiemJason on 24/03/2023.
//  Copyright © 2023 BaseSwift. All rights reserved.
//

import Alamofire
/**
 This API from https://www.appsloveworld.com/sample-rest-api-url-for-testing-with-authentication
 */
enum BaseEndpoint : String {
    /** `Auth` */
    case register   = "/authaccount/registration"
    case login      = "/authaccount/login"
    
    /** `User` */
    case user       = "/users"
    
    /** `Translate` */
    case translate = "/translate/"
    case likeorunlike = "/likeorunlike/"
    case suggest = "/suggest/"
}

enum BaseRouter {
#if Develop
    static let domain  = "103.121.90.177:8000"
    static let baseURL = "http://\(domain)"
#elseif Staging
    static let domain  = "103.121.90.177:8000"
    static let baseURL = "http://\(domain)"
#else
    static let domain  = "103.121.90.177:8000"
    static let baseURL = "http://\(domain)"
#endif
    
    /** `Auth` */
    case register(regisModel: BaseRegistrationModel)
    case login(loginModel: BaseLoginModel)
    
    /** `Translater` */
    case translate(model: TranslaterRequestModel)
    case likeofunlike(model: LikeUnLikeRequestModel)
    case suggest(model: SuggestRequestModel)
}

extension BaseRouter: URLRequestConvertible {
    // MARK: - Request Info
    var request: (HTTPMethod, String) {
        switch self {
            /** `Auth` */
        case .register(regisModel: _):
            return (.post, BaseEndpoint.register.rawValue)
        case .login(loginModel: _):
            return (.post, BaseEndpoint.login.rawValue)
        case .translate(model: _):
            return (.post, BaseEndpoint.translate.rawValue)
        case .likeofunlike(model: _):
            return (.post, BaseEndpoint.likeorunlike.rawValue)
        case .suggest(model: _):
            return (.post, BaseEndpoint.suggest.rawValue)
        }
    }
    
    //MARK: - Request Params
    /**
     ******************************************************************
     * Config Query & Body
     ******************************************************************
     */
    var params: [String: Any]? {
        switch self {
            /** `Auth` */
        case .register(regisModel: var regisModel):
            return regisModel.toJSON()
        case .login(loginModel: var loginModel):
            return loginModel.toJSON()
        case .translate(model: var translateModel):
            return translateModel.toJSON()
        case .likeofunlike(model: var likeorunlikeModel):
            return likeorunlikeModel.toJSON()
        case .suggest(model: var suggestModel):
            return suggestModel.toJSON()
        default:
            return [:]
        }
    }
}

// MARK: - Request Define
extension BaseRouter {
    func asURLRequest() throws -> URLRequest {
        let url = try BaseRouter.baseURL.asURL()
        let method = request.0
        let path = request.1
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        let jsonEncodingMethods: [HTTPMethod] = [.post, .put, .delete, .patch]
        let encoding: ParameterEncoding = jsonEncodingMethods.contains(method) ? JSONEncoding.default : URLEncoding.queryString
        urlRequest = try encoding.encode(urlRequest, with: params)
        return urlRequest
    }
}
