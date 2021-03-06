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

    public private (set) var url: NSURL
    public internal (set) var responseCode: Int?
    public internal (set) var isReachable: Bool = false
    public internal (set) var responseTimes: PurgingArray<NSTimeInterval> = PurgingArray(purgeCount: 100)
    private var authorization: Authorization?

    //MARK: Initialization
    public init?(urlString: String, interval: NSTimeInterval = 10, timeout: NSTimeInterval = 3, authorization: Authorization? = nil, onUpdate: OnUpdate? = nil) {
        guard let url = NSURL(string: urlString) else {
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

extension Endpoint: Hashable {
    //MARK: Hashable
    public var hashValue: Int {
        return url.hashValue
    }
}

extension Endpoint: Comparable { }
//MARK: Comparable
public func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
    return lhs.url == rhs.url
}

public func < (lhs: Endpoint, rhs: Endpoint) -> Bool {
    return lhs.url.absoluteString < rhs.url.absoluteString
}

extension Endpoint: CustomDebugStringConvertible {
    //MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        return "\(url.absoluteString)"
    }
}
