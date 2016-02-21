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
    //MARK: Tessts
    func testBasicAuthorization() {
        let expectedResult = "Z2VuZXJhbDpwaXNhcm0="
        let basicAuth: Authorization = .Basic(username: "general", password: "pisarm")

        XCTAssertEqual("Authorization", basicAuth.headerKey())
        XCTAssertEqual("Basic \(expectedResult)", basicAuth.headerValue())
    }

    func testBasicAuthorizationInvalidUTF8() {
        let cc: [unichar] = [0xd800]
        let invalidString = String(NSString(characters: cc, length: cc.count))

        let basicAuth: Authorization = .Basic(username: invalidString, password: invalidString)
        XCTAssertNil(basicAuth.headerValue())
    }

    func testTokenAuthorization() {
        let token = "1234123412341234"
        let tokenAuth: Authorization = .Token(token: token)

        XCTAssertEqual("Authorization", tokenAuth.headerKey())
        XCTAssertEqual("Bearer \(token)", tokenAuth.headerValue())
    }
}
