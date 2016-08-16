//
//  URLSessionProtocol.swift
//  Horizon
//
//  Created by Flemming Pedersen on 13/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public typealias DataTaskResult = (NSData?, NSURLResponse?, NSError?) -> Void

public protocol URLSessionProtocol {
    func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol
}

extension NSURLSession: URLSessionProtocol {
    //MARK:
    public func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTaskWithRequest(request: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
