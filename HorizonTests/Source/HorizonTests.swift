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


    //    func testHostReachable() {
    //        let expectation = expectationWithDescription("Host should be reachable with a given response code")
    //        let hostResponseCode = 200
    //        let hostURL = "http://pisarm.io"
    //
    //        session.nextData = "{}".dataUsingEncoding(NSUTF8StringEncoding)
    //        session.nextResponse = NSHTTPURLResponse(statusCode: hostResponseCode)
    //
    //        horizon.add(hostURL) { host in
    //            print("\(host.responseTime) \(host.meanResponseTime)")
    //            XCTAssertEqual(hostURL, host.url.absoluteString)
    //            XCTAssertEqual(hostResponseCode, host.responseCode)
    //            XCTAssertTrue(host.isReachable)
    //
    //            expectation.fulfill()
    //        }
    //        horizon.start()
    //
    //        waitForExpectationsWithTimeout(1, handler: nil)
    //    }
    //
    //    func testHostUnreachable() {
    //        let expectation = expectationWithDescription("Host should be unreachable")
    //        let hostURL = "http://pisarm.io"
    //
    //        session.nextError = NSError(domain: "", code: 7, userInfo: nil)
    //
    //        horizon.add(hostURL) { host in
    //            XCTAssertEqual(hostURL, host.url.absoluteString)
    //            XCTAssertFalse(host.isReachable)
    //
    //            expectation.fulfill()
    //        }
    //        horizon.start()
    //
    //        waitForExpectationsWithTimeout(1, handler: nil)
    //    }
}
