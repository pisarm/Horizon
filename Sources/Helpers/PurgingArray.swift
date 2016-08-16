//
//  PurgingArray.swift
//  Horizon
//
//  Created by Flemming Pedersen on 12/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public struct PurgingArray<T>: Collection, IteratorProtocol {
    public typealias Iterator = AnyIterator<T>

    public typealias Element = T

    public var purgeCount: Int
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

    public func makeIterator() -> Iterator {
        return AnyIterator(self)
    }

    public mutating func next() -> Element? {
        guard index != values.endIndex else {
            return nil
        }

        let obj = values[index]
        index += 1
        return obj
    }

    //MARK: IndexableBase
    public typealias Index = Array<T>.Index
    public typealias SubSequence = Array<T>

    public var startIndex: Index {
        return values.startIndex
    }

    public var endIndex: Index {
        return values.endIndex
    }

    public subscript(position: Index) -> Element {
        return values[position]
    }

    public subscript(bounds: Range<Index>) -> SubSequence {
        return Array(values[bounds])
    }

    public func index(after i: Index) -> Index {
        return values.index(after: i)
    }

    public func formIndex(after i: inout Index) {
        values.formIndex(after: &i)
    }
}
