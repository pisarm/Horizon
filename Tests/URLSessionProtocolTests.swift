//
//  URLSessionProtocolTests.swift
//  Horizon
//
//  Created by Flemming Pedersen on 19/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import XCTest
@testable import Horizon

final class URLSessionProtocolTests: XCTestCase {
    //MARK: Tests
    func testMockDataTaskWithRequest() {
        let dataTask = MockURLSession().dataTask(request: URLRequest(url: URL(string: "http://pisarm.io")!), completionHandler: { _, _, _ in })
        XCTAssertTrue(dataTask is MockURLSessionDataTask)
    }

    func testDataTaskWithRequest() {
        let dataTask = (URLSession.shared as URLSessionProtocol).dataTask(request: URLRequest(url: URL(string: "http://pisarm.io")!), completionHandler: { _, _, _ in })
        XCTAssertTrue(dataTask is URLSessionDataTask)
    }
}
