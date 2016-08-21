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
    var nextData: Data?
    var nextError: NSError?
    var nextResponse: URLResponse?

    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastUrl: URL?

    func dataTask(request: URLRequest, completionHandler: DataTaskResult) -> URLSessionDataTaskProtocol {
        lastUrl = request.url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
}

extension HTTPURLResponse {
    convenience init?(statusCode: Int) {
        self.init(url: URL(string: "http://pisarm.io")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}
