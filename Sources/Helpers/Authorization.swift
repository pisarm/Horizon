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

    func headerKey() -> String {
        return "Authorization"
    }

    func headerValue() -> String? {
        switch self {
        case let .Basic(username, password):
            guard let data = "\(username):\(password)".data(using: NSUTF8StringEncoding) else {
                return nil
            }

            let encodedData = data.base64EncodedData([])

            return "Basic \(String(data: encodedData, encoding: NSUTF8StringEncoding)!)"
        case let .Token(token):
            return "Bearer \(token)"
        }
    }
}
