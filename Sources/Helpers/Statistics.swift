//
//  Statistics.swift
//  Horizon
//
//  Created by Flemming Pedersen on 27/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public protocol Addable {
    static var Zero: Self { get }

    static func + (lhs: Self, rhs: Self) -> Self
}

extension Int: Addable {
    public static var Zero: Int { return 0 }
}

extension Double: Addable {
    public static var Zero: Double { return 0.0 }
}

public protocol DoubleConvertible {
    var doubleValue: Double { get }
}

extension Int: DoubleConvertible {
    public var doubleValue: Double { return Double(self) }
}

extension Double: DoubleConvertible {
    public var doubleValue: Double { return self }
}

public extension Sequence where Iterator.Element: Addable {
    var sum: Iterator.Element {
        return reduce(Iterator.Element.Zero, +)
    }
}

public extension Collection where Iterator.Element: Addable, Iterator.Element: DoubleConvertible, IndexDistance: DoubleConvertible {
    var average: Double? {
        guard !isEmpty else {
            return nil
        }

        return sum.doubleValue / count.doubleValue
    }

    func variance(isSample: Bool = false) -> Double? {
        if isSample {
            guard count > 2 else { return nil }
        } else {
            guard !isEmpty else { return nil }
        }

        let averageValue = average! //See guard in average property for implicit unwrapping

        let numerator = reduce(Generator.Element.Zero.doubleValue) { return $0.0.doubleValue + pow(averageValue - $0.1.doubleValue, 2) }

        if isSample {
            return numerator / (count.doubleValue - 1.doubleValue)
        }

        return numerator / count.doubleValue
    }

    func standardDeviation(isSample: Bool = false) -> Double? {
        guard let varianceValue = variance(isSample: isSample) else {
            return nil
        }
        return sqrt(varianceValue)
    }
}
