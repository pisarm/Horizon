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
    //MARK: Properties
    var horizon: Horizon!
    let session: MockURLSession = MockURLSession()

    //MARK: Setup
    override func setUp() {
        super.setUp()

        horizon = Horizon(urlSession: session)
    }

    override func tearDown() {
        horizon = nil

        super.tearDown()
    }

    //MARK: Tests
    func testAddEndpoint() {
        let pisarmDotIo: Endpoint! = Endpoint(urlString: "pisarm.io")
        horizon.add(pisarmDotIo)
        horizon.add(pisarmDotIo)    //Added twice to test that a given endpoint can only be added once
        XCTAssertEqual(1, horizon.endpoints.count)
    }

    func testRemoveEndpointByEndpoint() {
        let pisarmDotGeneral: Endpoint! = Endpoint(urlString: "pisarm.general")
        horizon.add(pisarmDotGeneral)
        horizon.remove(pisarmDotGeneral)
        XCTAssertEqual(0, horizon.endpoints.count)
    }

    func testRemoveEndpointByURL() {
        let pisarmDotIoString = "pisarm.io"
        let pisarmDotIo: Endpoint! = Endpoint(urlString: pisarmDotIoString)

        horizon.add(pisarmDotIo)
        horizon.remove(NSURL(string: pisarmDotIoString)!)
        horizon.remove(NSURL(string: pisarmDotIoString)!) //Removed twice intentionally

        XCTAssertEqual(0, horizon.endpoints.count)
    }

    func testNotRemovingEndpointByURL() {
        let pisarmDotIoString = "pisarm.io"
        let pisarmDotIo: Endpoint! = Endpoint(urlString: pisarmDotIoString)

        horizon.add(pisarmDotIo)
        horizon.remove(NSURL(string: "pisarm.not.found.here")!)

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

        let endpoint: Endpoint! = Endpoint(urlString: urlString) { endpoint, _ in
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

        let endpoint: Endpoint! = Endpoint(urlString: urlString) { _, _ in
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

        let endpoint: Endpoint! = Endpoint(urlString: urlString) { _, _ in
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
        let onUpdate: (endpoint: Endpoint, didChangeReachable: Bool) -> () = { _, _ in
            if count + 1 == 2 {
                XCTAssertEqual(Reachability.Full, self.horizon.reachability)
                expectation.fulfill()
            }

            count += 1
        }

        let endpoint: Endpoint! = Endpoint(urlString: urlString, onUpdate: onUpdate)
        let endpoint1: Endpoint! = Endpoint(urlString: urlString1, onUpdate: onUpdate)

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
        let onUpdate: (endpoint: Endpoint, didChangeReachable: Bool) -> () = { _, _ in
            if count == 0 {
                self.session.nextError = nil
            } else if count + 1 == 2 {
                XCTAssertEqual(Reachability.Partial, self.horizon.reachability)
                expectation.fulfill()
            }

            count += 1
        }

        let endpoint: Endpoint! = Endpoint(urlString: urlString, onUpdate: onUpdate)
        let endpoint1: Endpoint! = Endpoint(urlString: urlString1, onUpdate: onUpdate)

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
        let onUpdate: (endpoint: Endpoint, didChangeReachable: Bool) -> () = { _, _ in
            if count + 1 == 2 {
                XCTAssertEqual(Reachability.None, self.horizon.reachability)
                expectation.fulfill()
            }

            count += 1
        }

        let endpoint: Endpoint! = Endpoint(urlString: urlString, onUpdate: onUpdate)
        let endpoint1: Endpoint! = Endpoint(urlString: urlString1, onUpdate: onUpdate)

        horizon.add(endpoint)
        horizon.add(endpoint1)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testMonitoring() {
        let expectation = expectationWithDescription("Monitoring with a given intervel should be possible")

        let urlString = "http://pisarm.io"

        var countdown = 2
        let endpoint: Endpoint! = Endpoint(urlString: urlString, interval: 0.01) { _, _ in
            if countdown == 0 {
                expectation.fulfill()
            }

            countdown -= 1
        }

        horizon.add(endpoint)
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }

    func testReachabilityChange() {
        let expectation = expectationWithDescription("Monitoring with a given intervel should be possible")

        let urlString = "http://pisarm.io"
        let endpoint: Endpoint! = Endpoint(urlString: urlString, interval: 0.1)

        horizon.add(endpoint)
        var countdown = 2
        horizon.onReachabilityChange = { reachability, endpoint in
            if countdown == 0 {
                expectation.fulfill()
            } else if countdown % 2 == 0 {
                XCTAssertEqual(Reachability.Full, reachability)
                self.session.nextError = NSError(domain: "dk.pisarm.mock", code: 7, userInfo: nil)
            } else {
                XCTAssertEqual(Reachability.None, reachability)
                self.session.nextError = nil
            }

            countdown -= 1
        }
        horizon.startMonitoring()

        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
