//
//  Horizon.swift
//  Horizon
//
//  Created by Flemming Pedersen on 11/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public enum Reachability {
    case Full
    case Partial
    case None
}

public final class Horizon {
    //MARK: Properties
    public var onReachabilityChange: ((reachability: Reachability) -> ())?
    private(set) var isMonitoring: Bool = false
    private(set) var endpoints: [Endpoint] = []
    private let urlSession: URLSessionProtocol

    //MARK: Initialization
    public init(urlSession: URLSessionProtocol = NSURLSession.sharedSession(), onReachabilityChange: ((reachability: Reachability) -> ())? = nil) {
        self.urlSession = urlSession
    }
}

extension Horizon {
    //MARK:
    public func add(endpoint: Endpoint) {
        endpoints.append(endpoint)

        if isMonitoring {
            checkEndpoint(endpoint)
        }
    }

    public func remove(endpoint: Endpoint) {
        endpoints = endpoints.filter { $0.url.absoluteString != endpoint.url.absoluteString }
    }
}

extension Horizon {
    //MARK:
    public func startMonitoring() {
        isMonitoring = true

        endpoints.forEach { self.checkEndpoint($0) }
    }

    public func stopMonitoring() {
        isMonitoring = false
    }
}

extension Horizon {
    //MARK:
    var reachability: Reachability {
        let reachableEndPointCount = endpoints
            .map { return $0.isReachable ? 1 : 0 }
            .reduce(0, combine: +)

        switch reachableEndPointCount {
        case endpoints.count:
            return .Full
        case 0:
            return .None
        default:
            return .Partial
        }
    }
}

extension Horizon {
    //MARK:
    func checkEndpoint(endpoint: Endpoint) {
        let beginTime = NSDate.timeIntervalSinceReferenceDate()

        let dataTask = urlSession.dataTaskWithRequest(endpoint.request()) { _, response, error in
            let oldReachableValue = endpoint.isReachable
            let newReachableValue = error == nil ? true : false

            if let httpURLResponse = response as? NSHTTPURLResponse {
                endpoint.responseCode = httpURLResponse.statusCode
            }
            endpoint.responseTimes.append(NSDate.timeIntervalSinceReferenceDate() - beginTime)
            endpoint.isReachable = newReachableValue
            endpoint.onUpdate?(endpoint: endpoint, didChangeReachable: oldReachableValue != newReachableValue)

            if self.isMonitoring {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(endpoint.interval * NSTimeInterval(NSEC_PER_SEC)))

                dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
                    self?.checkEndpoint(endpoint)
                }
            }

        }



        dataTask.resume()
        //TODO: do we need to keep track of dataTasks?
    }

    //    func checkEndpoints() {
    //        let dispatchGroup = dispatch_group_create()
    //
    //        endpoints.forEach { endpoint in
    //            dispatch_group_enter(dispatchGroup)
    //
    //            let beginTime = NSDate.timeIntervalSinceReferenceDate()
    //
    //            urlSession.dataTaskWithRequest(endpoint.request()) { _, response, error in
    //                let oldReachableValue = endpoint.isReachable
    //                let newReachableValue = error == nil ? true : false
    //
    //                if let httpURLResponse = response as? NSHTTPURLResponse {
    //                    endpoint.responseCode = httpURLResponse.statusCode
    //                }
    //                endpoint.responseTimes.append(NSDate.timeIntervalSinceReferenceDate() - beginTime)
    //                endpoint.isReachable = newReachableValue
    //                endpoint.onUpdate?(endpoint: endpoint, didChangeReachable: oldReachableValue != newReachableValue)
    //
    //                dispatch_group_leave(dispatchGroup)
    //                }.resume()
    //        }
    //
    //        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue()) { [weak self] in
    //            if (self?.isMonitoring) != nil {
    //                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self!.monitorInterval * NSTimeInterval(NSEC_PER_SEC)))
    //
    //                dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
    //                    self?.checkEndpoints()
    //                }
    //            }
    //        }
    //    }
}
