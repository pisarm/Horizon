//
//  Horizon.swift
//  Horizon
//
//  Created by Flemming Pedersen on 11/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public final class Horizon {
    //MARK: Properties
    public var endpoints: [Endpoint] { return Array(endpointTaskMap.keys) }
    public var onReachabilityChange: ((reachability: Reachability, endpoint: Endpoint) -> ())?
    private(set) var isMonitoring: Bool = false
    private var endpointTaskMap: [Endpoint : URLSessionDataTaskProtocol?] = [:]
    private let urlSession: URLSessionProtocol

    //MARK: Initialization
    public init(urlSession: URLSessionProtocol = NSURLSession.sharedSession(), onReachabilityChange: ((reachability: Reachability, endpoint: Endpoint) -> ())? = nil) {
        self.urlSession = urlSession
    }
}

extension Horizon {
    //MARK:
    public func add(endpoint: Endpoint) {
        guard endpointTaskMap[endpoint] == nil else {
            return
        }

        endpointTaskMap[endpoint] = nil as URLSessionDataTaskProtocol?

        if isMonitoring {
            checkEndpoint(endpoint)
        }
    }

    public func remove(endpoint: Endpoint) {
        endpointTaskMap[endpoint]??.cancel()
        endpointTaskMap[endpoint] = nil
    }

    public func remove(endpointWithURL: NSURL) {
        guard let (endpoint, task) = endpointTaskMap.filter({ $0.0.url == endpointWithURL }).first else {
            return
        }

        task?.cancel()
        endpointTaskMap[endpoint] = nil
    }
}

extension Horizon {
    //MARK:
    public func startMonitoring() {
        guard isMonitoring == false else {
            return
        }

        isMonitoring = true

        endpointTaskMap.forEach { self.checkEndpoint($0.0) }
    }

    public func stopMonitoring() {
        isMonitoring = false

        endpointTaskMap.forEach { $0.1?.cancel() }
    }
}

extension Horizon {
    //MARK:
    var reachability: Reachability {
        let reachableEndPointCount = endpointTaskMap
            .keys
            .map { return $0.isReachable ? 1 : 0 }
            .reduce(0, combine: +)

        switch reachableEndPointCount {
        case endpointTaskMap.count:
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

            if oldReachableValue != newReachableValue {
                self.onReachabilityChange?(reachability: self.reachability, endpoint: endpoint)
            }

            if self.isMonitoring {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(endpoint.interval * NSTimeInterval(NSEC_PER_SEC)))

                dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
                    self?.checkEndpoint(endpoint)
                }
            }
        }

        // If the endpoint hasn't been removed from the list of endpoints while we were waiting we
        // add and resume
        if let _ = endpointTaskMap[endpoint] {
            endpointTaskMap[endpoint] = dataTask
            dataTask.resume()
        }
    }
}
