//
//  URLSessionDataTask.swift
//  Horizon
//
//  Created by Flemming Pedersen on 13/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension NSURLSessionDataTask: URLSessionDataTaskProtocol { }
