//
//  PurgingArray.swift
//  Horizon
//
//  Created by Flemming Pedersen on 12/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

struct PurgingArray<T>: CollectionType, GeneratorType {
    typealias Generator = AnyGenerator<T>
    typealias Index = Array<T>.Index
    typealias Element = T

    var purgeCount: Int
    var startIndex: Index { return values.startIndex }
    var endIndex: Index { return values.endIndex }
    private var values: [T] = []
    private var index = 0

    init(purgeCount: Int = 100) {
        self.purgeCount = purgeCount
    }

    mutating func append(value: T) {
        if values.count == purgeCount {
            values.removeFirst()
        }
        values.append(value)
    }

    func generate() -> Generator {
        return anyGenerator(self)
    }

    mutating func next() -> Element? {
        guard index != values.endIndex else {
            return nil
        }

        let obj = values[index]
        index += 1
        return obj
    }

    subscript(index: Index) -> Element {
        return values[index]
    }
}
