//
//  StatisticsTests.swift
//  Horizon
//
//  Created by Flemming Pedersen on 29/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation
import Foundation
import XCTest
@testable import Horizon

final class StatisticsTests: XCTestCase {
    //MARK: Properties
    let emptyIntegers: [Int] = []
    let emptyDoubles: [Double] = []

    let oneInteger: [Int] = [1]
    let oneDouble: [Double] = [1.0]

    let integers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let doubles: [Double] =  [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]

    //MARK: Tests
    func testAverageGuards() {
        XCTAssertNil(emptyIntegers.average)
        XCTAssertNil(emptyDoubles.average)
    }

    func testAverage() {
        XCTAssertEqual(5.5, integers.average)
        XCTAssertEqual(5.5, doubles.average)

    }

    func testVariance() {
        XCTAssertNil(emptyIntegers.variance())
        XCTAssertEqual(0, oneInteger.variance()!)
        XCTAssertEqual(8.25, integers.variance()!)

        XCTAssertNil(emptyDoubles.variance())
        XCTAssertEqual(0, oneDouble.variance()!)
        XCTAssertEqual(8.25, doubles.variance()!)
    }

    func testVarianceSample() {
        XCTAssertNil(oneInteger.variance(isSample: true))
        XCTAssertEqual(9.1666666666666667, integers.variance(isSample: true)!)

        XCTAssertNil(oneDouble.variance(isSample: true))
        XCTAssertEqual(9.1666666666666667, doubles.variance(isSample: true)!)
    }

    func testStandardDeviation() {
        XCTAssertNil(emptyIntegers.standardDeviation())
        XCTAssertEqual(2.87228132326901, integers.standardDeviation())
        XCTAssertEqual(3.02765035409749, integers.standardDeviation(isSample: true))

        XCTAssertNil(emptyDoubles.standardDeviation(isSample: true))
        XCTAssertEqual(2.87228132326901, doubles.standardDeviation())
        XCTAssertEqual(3.02765035409749, doubles.standardDeviation(isSample: true))
    }
}
