//
//  LogoEndPoint.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import Foundation

struct LogoEndPoint: EndPointType {
    
    init(baseUrl: String) {
        switch Connection.environment {
        case .production:
            environmentBaseURL = baseUrl
        case .qa:
            environmentBaseURL = baseUrl
        case .staging:
            environmentBaseURL = baseUrl
        }
    }
    
    var environmentBaseURL: String!
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String = ""
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
