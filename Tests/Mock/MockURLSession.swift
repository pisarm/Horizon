//
//  MockURLSession.swift
//  Horizon
//
//  Created by Flemming Pedersen on 13/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
@testable import Horizon

final class MockURLSession: URLSessionProtocol {
    var nextData: NSData?
    var nextError: NSError?
    var nextResponse: NSURLResponse?

    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: NSURL?

    func dataTaskWithURL(url: NSURL, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }

    func dataTaskWithRequest(request: NSURLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}

extension NSHTTPURLResponse {
    convenience init?(statusCode: Int) {
        self.init(url: NSURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}
