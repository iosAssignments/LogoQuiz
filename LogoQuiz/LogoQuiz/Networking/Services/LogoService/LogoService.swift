//
//  LogoService.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import Foundation
import UIKit

enum Result<String>{
    case success
    case failure(String)
}

struct LogoService {
    let connection = Connection()
    
    func getLogo(for urlString: String, completion: @escaping (_ imageData: UIImage?,_ error: String?)->()){
        connection.request(LogoEndPoint(baseUrl: urlString)) { data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil, error.debugDescription)
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        completion(UIImage(data: responseData), nil)
                        
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        return .success
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
