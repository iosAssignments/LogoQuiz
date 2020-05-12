//
//  NetworkingTypes.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
}

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

enum NetworkResponse:String {
    case success
    case authenticationError = "Please authenticate first."
    case badRequest = "Bad request"
    case outdated = "The requested resource is outdated."
    case failed = "Request failed."
    case noData = "Response returned with no data"
    case unableToDecode = "Unable to decode the response."
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
}
