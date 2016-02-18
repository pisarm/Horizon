//
//  Endpoint.swift
//  Horizon
//
//  Created by Flemming Pedersen on 14/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public final class Endpoint {
    //MARK: Properties
    var authorization: Authorization?
    var isReachable: Bool = false
    var responseCode: Int?
    var responseTimes: PurgingArray<NSTimeInterval> = PurgingArray()
    var timeout: NSTimeInterval
    var url: NSURL
    let changeAction: ((endpoint: Endpoint) -> ())?

    //MARK: Initialization
    public init?(urlString: String, timeout: NSTimeInterval = 3, changeAction: ((endpoint: Endpoint) -> ())? = nil) {
        guard let url = NSURL(string: urlString) else {
            //TODO: Remove fake init when Swift 2.2 arrives - bug in 2.1
            self.changeAction = nil
            self.timeout = 0
            self.url = NSURL()
            return nil
        }

        self.url = url
        self.timeout = timeout
        self.changeAction = changeAction
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
