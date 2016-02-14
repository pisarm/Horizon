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
    //MARK:
    override func setUp() {
        super.setUp()

    }

    override func tearDown() {

        super.tearDown()
    }

    func testFailingInit() {
        let endpoint = Endpoint(urlString: " ")
        XCTAssertNil(endpoint)
    }

    func testEquality() {
        XCTFail()
    }

    func testLessThan() {
        XCTFail()
    }
}
