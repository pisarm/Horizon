//
//  AuthorizationTests.swift
//  Horizon
//
//  Created by Flemming Pedersen on 15/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import XCTest
@testable import Horizon

final class AuthorizationTests: XCTestCase {
    //MARK:
    override func setUp() {
        super.setUp()

    }

    override func tearDown() {

        super.tearDown()
    }

    //MARK:
    func testBasicAuthorization() {
        let basicAuth: Authorization = .Basic(username: "general", password: "pisarm")
        let expectedResult = "Z2VuZXJhbDpwaXNhcm0="

        XCTAssertEqual("Authorization", basicAuth.headerKey())
        XCTAssertEqual("Basic \(expectedResult)", basicAuth.headerValue())
    }

    func testTokenAuthorization() {
        let token = "1234123412341234"
        let tokenAuth: Authorization = .Token(token: token)

        XCTAssertEqual("Authorization", tokenAuth.headerKey())
        XCTAssertEqual("Bearer \(token)", tokenAuth.headerValue())
    }
}
