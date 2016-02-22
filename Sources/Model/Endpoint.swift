//
//  Endpoint.swift
//  Horizon
//
//  Created by Flemming Pedersen on 14/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public final class Endpoint {
    //MARK: Typealias
    public typealias OnUpdate = (endpoint: Endpoint, didChangeReachable: Bool) -> ()

    //MARK: Properties
    public var interval: NSTimeInterval
    public var timeout: NSTimeInterval
    public var onUpdate: ((endpoint: Endpoint, didChangeReachable: Bool) -> ())?
    public var lastResponseTime: NSTimeInterval? { return responseTimes.last }
    public var meanResponseTime: NSTimeInterval { return responseTimes.reduce(0, combine: +) / Double(responseTimes.count) }
    public private(set) var url: NSURL
    public internal(set) var responseCode: Int?
    public internal(set) var isReachable: Bool = false
    internal var responseTimes: PurgingArray<NSTimeInterval> = PurgingArray()
    private var authorization: Authorization?

    //MARK: Initialization
    public init?(urlString: String, interval: NSTimeInterval = 10, timeout: NSTimeInterval = 3, authorization: Authorization? = nil, onUpdate: OnUpdate? = nil) {
        guard let url = NSURL(string: urlString) else {
            //TODO: Remove fake init when Swift 2.2 arrives - bug in 2.1
            self.onUpdate = nil
            self.interval = 0
            self.timeout = 0
            self.url = NSURL()
            return nil
        }

        self.authorization = authorization
        self.url = url
        self.interval = interval
        self.timeout = timeout
        self.onUpdate = onUpdate
    }

    func request() -> NSURLRequest {
        let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout)
        if let authorization = self.authorization, headerValue = authorization.headerValue() {
            request.addValue(headerValue, forHTTPHeaderField: authorization.headerKey())
        }

        return request
    }
}

extension Endpoint: Comparable { }
//MARK: Comparable
public func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
    return lhs.url.absoluteString == rhs.url.absoluteString
}

public func < (lhs: Endpoint, rhs: Endpoint) -> Bool {
    return lhs.url.absoluteString < rhs.url.absoluteString
}
