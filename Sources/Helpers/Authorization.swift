//
//  Authorization.swift
//  Horizon
//
//  Created by Flemming Pedersen on 15/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

/**
 Authorization:
 - **Basic**: Used for basic authentication
 - **Token**: Used for token based authentication (OAuth, JWT, etc)
 */
public enum Authorization {
    case Basic(username: String, password: String)
    case Token(token: String)

    /**
     headerKey: Generates the key for the HTTP authorization header.
     - returns: String containing the word "*Authorization*"
     */
    func headerKey() -> String {
        return "Authorization"
    }

    /**
     headerValue: Generates an HTTP Authorization header value
     - returns: The correctly initialized value used for authorization or nil if it fails
     */
    func headerValue() -> String? {
        switch self {
        case let .Basic(username, password):
            guard let data = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding) else {
                return nil
            }

            let encodedData = data.base64EncodedDataWithOptions([])

            return "Basic \(String(data: encodedData, encoding: NSUTF8StringEncoding)!)"
        case let .Token(token):
            return "Bearer \(token)"
        }
    }
}
