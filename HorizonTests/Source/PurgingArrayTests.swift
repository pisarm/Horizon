//
//  PurgingArrayTests.swift
//  Horizon
//
//  Created by Flemming Pedersen on 13/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import XCTest
@testable import Horizon

class PurgingArrayTests: XCTestCase {
    var purgingArray: PurgingArray<Int>!

    override func setUp() {
        super.setUp()

        purgingArray = PurgingArray(purgeCount: 10)
    }

    override func tearDown() {
        purgingArray = nil

        super.tearDown()
    }

    func testAdd() {
        for i in 0...9 {
            purgingArray.append(i)
        }

        for i in 0...9 {
            XCTAssertEqual(i, purgingArray[i])
        }
    }

    func testStartIndex() {
        for i in 0...9 {
            purgingArray.append(i)
        }

        XCTAssertEqual(5, purgingArray[purgingArray.startIndex.advancedBy(5)])
    }

    func testEndIndex() {
        for i in 0...9 {
            purgingArray.append(i)
        }

        XCTAssertEqual(5, purgingArray[purgingArray.endIndex.advancedBy(-5)])
    }

    func testPurge() {
        for i in 0...14 {
            purgingArray.append(i)
        }

        for i in purgingArray {
            XCTAssertEqual(i, purgingArray[i-5])
        }
    }
}
