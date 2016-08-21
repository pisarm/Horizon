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
    public typealias OnUpdate = (_ endpoint: Endpoint, _ didChangeReachable: Bool) -> ()

    //MARK: Properties
    public var interval: DispatchTimeInterval
    public var timeout: TimeInterval
    public var onUpdate: OnUpdate?

    public private (set) var url: URL
    public internal (set) var responseCode: Int?
    public internal (set) var isReachable: Bool = false
    public internal (set) var responseTimes: PurgingArray<TimeInterval> = PurgingArray(purgeCount: 100)
    private var authorization: Authorization?

    //MARK: Initialization
    public init?(urlString: String, interval: DispatchTimeInterval = .seconds(10), timeout: TimeInterval = 3, authorization: Authorization? = nil, onUpdate: OnUpdate? = nil) {
        guard let url = URL(string: urlString) else {
            return nil
        }

        self.authorization = authorization
        self.url = url
        self.interval = interval
        self.timeout = timeout
        self.onUpdate = onUpdate
    }

    func request() -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout)
        if let authorization = self.authorization, let headerValue = authorization.value {
            request.addValue(headerValue, forHTTPHeaderField: authorization.key)
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

extension Endpoint: Comparable {
    //MARK: Comparable
    public static func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
        return lhs.url == rhs.url
    }

    public static func < (lhs: Endpoint, rhs: Endpoint) -> Bool {
        return lhs.url.absoluteString < rhs.url.absoluteString
    }
}

extension Endpoint: CustomDebugStringConvertible {
    //MARK: CustomDebugStringConvertible
    public var debugDescription: String {
        return "\(url.absoluteString)"
    }
}
