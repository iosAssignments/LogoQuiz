//
//  Connection.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import Foundation

typealias ConnectionRequestCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()

class Connection {
    static let environment : NetworkEnvironment = .production

    private var task: URLSessionTask?
    private let session = URLSession(configuration: .default)
    
    func request(_ endPoint: EndPointType, completion: @escaping ConnectionRequestCompletion) {
        let request = self.buildRequest(from: endPoint)
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            completion(data, response, error)
        })
        self.task?.resume()
    }
    
    private func buildRequest(from endPoint: EndPointType) -> URLRequest {
        
        var request = URLRequest(url: endPoint.baseURL.appendingPathComponent(endPoint.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = endPoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
