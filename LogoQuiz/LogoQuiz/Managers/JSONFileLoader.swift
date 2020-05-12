//
//  JSONFileLoader.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/11/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import Foundation

struct JSONFileLoader {
    static func load<T : Decodable>(filename fileName: String, into type: [T].Type) -> [T]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(type.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
