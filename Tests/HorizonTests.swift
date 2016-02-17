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
        let pisarmDotIo: Endpoint! = Endpoint(urlString: "pisarm.io")
        horizon.add(pisarmDotIo)
        XCTAssertEqual(1, horizon.endpoints.count)
    }

    func testRemoveHost() {
        let pisarmDotIo: Endpoint! = Endpoint(urlString: "pisarm.io")
        let pisarmDotGeneral: Endpoint! = Endpoint(urlString: "pisarm.general")

        horizon.add(pisarmDotIo)
        horizon.add(pisarmDotGeneral)
        horizon.remove(pisarmDotGeneral)
        XCTAssertEqual(1, horizon.endpoints.count)
    }

    func testStartMonitoring() {
        horizon.startMonitoring()
        XCTAssertTrue(horizon.isMonitoring)
    }

    func testStopMonitoring() {
        horizon.startMonitoring()
        horizon.stopMonitoring()
        XCTAssertFalse(horizon.isMonitoring)
    }

    func testEndpointResponseCode() {
        let responseCode = 418
        session.nextResponse = NSHTTPURLResponse(statusCode: responseCode)

        let expectation = expectationWithDescription("Single endpoint should be reachable")

        let urlString = "http://pisarm.io"

        let endpoint: Endpoint! = Endpoint(urlString: urlString) { endpoint in
            XCTAssertEqual(responseCode, endpoint.responseCode)
            expectation.fulfill()
        }

        horizon.add(endpoint)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testSingleEndpointReachable() {
        let expectation = expectationWithDescription("Single endpoint should be reachable")

        let urlString = "http://pisarm.io"

        let endpoint: Endpoint! = Endpoint(urlString: urlString) { _ in
            XCTAssertEqual(Reachability.Full, self.horizon.reachability)
            expectation.fulfill()
        }

        horizon.add(endpoint)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testSingleEndPointUnreachable() {
        session.nextError = NSError(domain: "dk.pisarm.mock", code: 7, userInfo: nil)

        let expectation = expectationWithDescription("Single endpoint should be unreachable")

        let urlString = "http://pisarm.io"

        let endpoint: Endpoint! = Endpoint(urlString: urlString) { _ in
            XCTAssertEqual(Reachability.None, self.horizon.reachability)
            expectation.fulfill()
        }

        horizon.add(endpoint)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testMultipleEndpointsReachable() {
        let expectation = expectationWithDescription("Multiple endpoints should be reachable")

        let urlString = "http://pisarm.io"
        let urlString1 = "http://pisarm.info"

        var count = 0
        let completion: (endpoint: Endpoint) -> () = { _ in
            if count + 1 == 2 {
                XCTAssertEqual(Reachability.Full, self.horizon.reachability)
                expectation.fulfill()
            }

            count += 1
        }

        let endpoint: Endpoint! = Endpoint(urlString: urlString, changeAction: completion)
        let endpoint1: Endpoint! = Endpoint(urlString: urlString1, changeAction: completion)

        horizon.add(endpoint)
        horizon.add(endpoint1)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testMultipleEndPointsPartiallyReachable() {
        session.nextError = NSError(domain: "dk.pisarm.mock", code: 7, userInfo: nil)

        let expectation = expectationWithDescription("Multiple endpoints should be unreachable")

        let urlString = "http://pisarm.io"
        let urlString1 = "http://pisarm.info"

        var count = 0
        let completion: (endpoint: Endpoint) -> () = { _ in
            if count == 0 {
                self.session.nextError = nil
            } else if count + 1 == 2 {
                XCTAssertEqual(Reachability.Partial, self.horizon.reachability)
                expectation.fulfill()
            }

            count += 1
        }

        let endpoint: Endpoint! = Endpoint(urlString: urlString, changeAction: completion)
        let endpoint1: Endpoint! = Endpoint(urlString: urlString1, changeAction: completion)

        horizon.add(endpoint)
        horizon.add(endpoint1)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testMultipleEndpointsUnreachable() {
        session.nextError = NSError(domain: "dk.pisarm.mock", code: 7, userInfo: nil)

        let expectation = expectationWithDescription("Multiple endpoints should be unreachable")

        let urlString = "http://pisarm.io"
        let urlString1 = "http://pisarm.info"

        var count = 0
        let completion: (endpoint: Endpoint) -> () = { _ in
            if count + 1 == 2 {
                XCTAssertEqual(Reachability.None, self.horizon.reachability)
                expectation.fulfill()
            }

            count += 1
        }

        let endpoint: Endpoint! = Endpoint(urlString: urlString, changeAction: completion)
        let endpoint1: Endpoint! = Endpoint(urlString: urlString1, changeAction: completion)

        horizon.add(endpoint)
        horizon.add(endpoint1)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
