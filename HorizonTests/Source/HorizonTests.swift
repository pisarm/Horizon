//
//  HorizonTests.swift
//  HorizonTests
//
//  Created by Flemming Pedersen on 11/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import XCTest
@testable import Horizon

class HorizonTests: XCTestCase {
    var horizon: Horizon!
    let session: MockURLSession = MockURLSession()
    //MARK:
    override func setUp() {
        super.setUp()

        horizon = Horizon(urlSession: session)
    }

    override func tearDown() {
        horizon = nil

        super.tearDown()
    }

    func testAddHost() {
        horizon.add("pisarm.io", action: { _ in })
        XCTAssertEqual(1, horizon.hosts.count)
    }

    func testRemoveHost() {
        horizon.add("pisarm.io", action: { _ in })
        horizon.add("pisarm.xxx", action: { _ in })
        horizon.remove("pisarm.xxx")
        XCTAssertEqual(1, horizon.hosts.count)
    }

    func testHostReachable() {
        let expectation = expectationWithDescription("Host should be reachable with a given response code")
        let hostResponseCode = 200
        let hostURL = "http://pisarm.io"

        session.nextData = "{}".dataUsingEncoding(NSUTF8StringEncoding)
        session.nextResponse = NSHTTPURLResponse(statusCode: hostResponseCode)

        horizon.add(hostURL) { host in
            print("\(host.responseTime) \(host.meanResponseTime)")
            XCTAssertEqual(hostURL, host.url.absoluteString)
            XCTAssertEqual(hostResponseCode, host.responseCode)
            XCTAssertTrue(host.isReachable)

            expectation.fulfill()
        }
        horizon.start()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testHostUnreachable() {
        let expectation = expectationWithDescription("Host should be unreachable")
        let hostURL = "http://pisarm.io"

        session.nextError = NSError(domain: "", code: 7, userInfo: nil)

        horizon.add(hostURL) { host in
            XCTAssertEqual(hostURL, host.url.absoluteString)
            XCTAssertFalse(host.isReachable)

            expectation.fulfill()
        }
        horizon.start()

        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
