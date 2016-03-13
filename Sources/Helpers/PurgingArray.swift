//
//  PurgingArray.swift
//  Horizon
//
//  Created by Flemming Pedersen on 12/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

/**
 PurgingArray: CollectionType that has the same overall characteristics as an Array. PurgingArray 
 requires you to specify a *purgeCount* property, which is the point at which the array will start 
 purging elements FIFO-style.
 */
public struct PurgingArray<T>: CollectionType, GeneratorType {
    public typealias Generator = AnyGenerator<T>
    public typealias Index = Array<T>.Index
    public typealias Element = T

    public var purgeCount: Int
    public var startIndex: Index { return values.startIndex }
    public var endIndex: Index { return values.endIndex }
    private var values: [T] = []
    private var index = 0

    init(purgeCount: Int) {
        self.purgeCount = purgeCount
    }

    mutating func append(value: T) {
        if values.count == purgeCount {
            values.removeFirst()
        }
        values.append(value)
    }

    public func generate() -> Generator {
        return anyGenerator(self)
    }

    public mutating func next() -> Element? {
        guard index != values.endIndex else {
            return nil
        }

        let obj = values[index]
        index += 1
        return obj
    }

    public subscript(index: Index) -> Element {
        return values[index]
    }
}
