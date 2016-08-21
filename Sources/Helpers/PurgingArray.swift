//
//  PurgingArray.swift
//  Horizon
//
//  Created by Flemming Pedersen on 12/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

// Greatly simplified; thank you Chris: http://chris.eidhof.nl/post/protocols-in-swift/

public struct PurgingArray<T> {
    public var purgeCount: Int
    fileprivate var elements: [T] = []

    init(purgeCount: Int) {
        self.purgeCount = purgeCount
    }

    mutating func append(_ element: T) {
        if elements.count == purgeCount {
            elements.removeFirst()
        }
        elements.append(element)
    }
}

extension PurgingArray: Collection {
    //MARK: Collection
    public var startIndex: Int { return elements.startIndex }
    public var endIndex: Int { return elements.endIndex }

    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }

    public subscript(position: Int) -> T {
        return elements[position]
    }
}
