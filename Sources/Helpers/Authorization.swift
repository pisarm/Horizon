//
//  Authorization.swift
//  Horizon
//
//  Created by Flemming Pedersen on 15/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public enum Authorization {
    case Basic(username: String, password: String)
    case Token(token: String)

    var key: String {
        return "Authorization"
    }

    var value: String? {
        switch self {
        case let .Basic(username, password):
            guard let data = "\(username):\(password)".data(using: .utf8) else {
                return nil
            }

            let encodedData = data.base64EncodedData(options: [])

            return "Basic \(String(data: encodedData, encoding: .utf8)!)"
        case let .Token(token):
            return "Bearer \(token)"
        }
    }

}
