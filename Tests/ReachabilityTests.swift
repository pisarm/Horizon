//
//  ReachabilityTests.swift
//  Horizon
//
//  Created by Flemming Pedersen on 25/03/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import XCTest

@testable import Horizon

final class ReachabilityTests: XCTestCase {
    func testFullString() {
        let reachability: Reachability = .Full

        XCTAssertEqual("Full", reachability.description)
    }

    func testPartialString() {
        let reachability: Reachability = .Partial

        XCTAssertEqual("Partial", reachability.description)
    }

    func testNoneString() {
        let reachability: Reachability = .None

        XCTAssertEqual("None", reachability.description)
    }
}
