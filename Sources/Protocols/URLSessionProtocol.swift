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
    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol
    func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol
}

extension NSURLSession: URLSessionProtocol {
    public func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTaskWithURL(url, completionHandler: completionHandler) as NSURLSessionDataTask) as URLSessionDataTaskProtocol
    }

    public func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTaskWithRequest(request, completionHandler: completionHandler) as NSURLSessionDataTask) as URLSessionDataTaskProtocol
    }
}
