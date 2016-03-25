//
//  Reachability.swift
//  Horizon
//
//  Created by Flemming Pedersen on 25/03/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public enum Reachability: String {
    case Full
    case Partial
    case None
}

extension Reachability: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}
