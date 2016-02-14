//
//  Endpoint.swift
//  Horizon
//
//  Created by Flemming Pedersen on 14/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public final class Endpoint {
    //MARK: Properties
    var isReachable: Bool = false
    var responseCode: Int?
    var responseTimes: PurgingArray<NSTimeInterval> = PurgingArray()
    var url: NSURL
    let changeAction: ((endpoint: Endpoint) -> ())?

    //MARK: Initialization
    init?(urlString: String, changeAction: ((endpoint: Endpoint) -> ())? = nil) {
        guard let url = NSURL(string: urlString) else {
            //TODO: Remove next two lines when Swift 2.2 arrives - bug in 2.1
            self.changeAction = nil
            self.url = NSURL()
            return nil
        }

        self.url = url
        self.changeAction = changeAction
    }
}

extension Endpoint: Comparable { }
//MARK: Comparable
public func == (lhs: Endpoint, rhs: Endpoint) -> Bool {
    return lhs.url.absoluteString == rhs.url.absoluteString
}

public func < (lhs: Endpoint, rhs: Endpoint) -> Bool {
    return lhs.url.absoluteString < rhs.url.absoluteString
}
