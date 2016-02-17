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
        let expectation = expectationWithDescription("Single endpoint should be unreachable")

        let urlString = "http://pisarm.io"

        let endpoint: Endpoint! = Endpoint(urlString: urlString) { _ in
            XCTAssertEqual(Reachability.None, self.horizon.reachability)
            expectation.fulfill()
        }

        session.nextError = NSError(domain: "", code: 7, userInfo: nil)  //TODO: This can be done smarter

        horizon.add(endpoint)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testMultipleEndpointsReachable() {
        XCTFail()
    }

    func testMultipleEndPointsPartiallyReachable() {
        XCTFail()
    }

    func testMultipleEndpointsUnreachable() {
        XCTFail()
    }
}
