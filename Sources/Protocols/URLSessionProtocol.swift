//
//  URLSessionProtocol.swift
//  Horizon
//
//  Created by Flemming Pedersen on 13/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public typealias DataTaskResult = @escaping (Data?, URLResponse?, Error?) -> Void

public protocol URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    //MARK: URLSessionProtocol
    public func dataTask(request: URLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
