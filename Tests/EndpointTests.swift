//
//  EndpointTests.swift
//  Horizon
//
//  Created by Flemming Pedersen on 14/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import XCTest
@testable import Horizon

final class EndpointTests: XCTestCase {
    //MARK: Tests
    func testFailingInit() {
        let endpoint = Endpoint(urlString: " ")
        XCTAssertNil(endpoint)
    }

    func testRequest() {
        let urlString = "http://pisarm.io"
        let timeout: NSTimeInterval = 5
        let token = "1234"
        let authorization: Authorization = .Token(token: token)

        let endpoint: Endpoint! = Endpoint(urlString: urlString, timeout: timeout, authorization: authorization)

        let request = endpoint.request()

        XCTAssertEqual(urlString, request.URL!.absoluteString)
        XCTAssertEqual(timeout, request.timeoutInterval)
        XCTAssertNotNil(request.allHTTPHeaderFields!["Authorization"])
        XCTAssertEqual("Bearer \(token)", request.allHTTPHeaderFields!["Authorization"]!)
    }

    func testLastResponseTime() {
        let responseTime: NSTimeInterval = 1
        let endpoint: Endpoint! = Endpoint(urlString: "http://pisarm.io")
        endpoint.responseTimes.append(responseTime)
        XCTAssertEqual(responseTime, endpoint.responseTimes.last)
    }

    func testMeanResponseTime() {
        let endpoint: Endpoint! = Endpoint(urlString: "http://pisarm.io")
        for i in 1...10 {
            endpoint.responseTimes.append(NSTimeInterval(i))
        }
        XCTAssertEqual(5.5, endpoint.responseTimes.average)
    }

    func testEquality() {
        let urlString = "http://pisarm.io"
        let endpoint: Endpoint! = Endpoint(urlString: urlString)
        let anotherEndpoint: Endpoint! = Endpoint(urlString: urlString)

        XCTAssertEqual(endpoint, anotherEndpoint)
    }

    func testLessThan() {
        let endpoint: Endpoint! = Endpoint(urlString: "http://pisarm.io")
        let anotherEndpoint: Endpoint! = Endpoint(urlString: "http://pisarm.dk")

        XCTAssertLessThan(anotherEndpoint, endpoint)
    }

    func testCustomDebugStringConvertible() {
        let urlString = "http://pisarm.io"
        let endpoint: Endpoint! = Endpoint(urlString: urlString)
        XCTAssertEqual(urlString, endpoint.debugDescription)
    }
}
