//
//  Horizon.swift
//  Horizon
//
//  Created by Flemming Pedersen on 11/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public final class Horizon {
    //MARK: Typealiases
    public typealias ReachabilityChangeHandler = (_ reachability: Reachability, _ endpoint: Endpoint) -> ()

    //MARK: Properties
    public var endpoints: [Endpoint] { return Array(endpointTaskMap.keys) }
    public var onReachabilityChange: ReachabilityChangeHandler?
    fileprivate (set) var isMonitoring: Bool = false
    fileprivate var endpointTaskMap: [Endpoint : URLSessionDataTaskProtocol?] = [:]
    fileprivate let urlSession: URLSessionProtocol

    //MARK: Initialization
    public init(urlSession: URLSessionProtocol = URLSession.shared, onReachabilityChange: ReachabilityChangeHandler? = nil) {
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
            check(endpoint: endpoint)
        }
    }

    public func remove(endpoint: Endpoint) {
        endpointTaskMap[endpoint]??.cancel()
        endpointTaskMap[endpoint] = nil
    }

    public func remove(endpointWithUrl: URL) {
        guard let (endpoint, task) = endpointTaskMap.filter({ $0.0.url == endpointWithUrl }).first else {
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

        endpointTaskMap.forEach { self.check(endpoint: $0.0) }
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
            .reduce(0, +)

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
    func check(endpoint: Endpoint) {
        let beginTime = Date.timeIntervalSinceReferenceDate

        let dataTask = urlSession.dataTask(request: endpoint.request()) { _, response, error in
            let oldReachableValue = endpoint.isReachable
            let newReachableValue = error == nil ? true : false

            if let httpURLResponse = response as? HTTPURLResponse {
                endpoint.responseCode = httpURLResponse.statusCode
            }
            endpoint.responseTimes.append(Date.timeIntervalSinceReferenceDate - beginTime)
            endpoint.isReachable = newReachableValue
            endpoint.onUpdate?(endpoint, oldReachableValue != newReachableValue)

            if oldReachableValue != newReachableValue {
                self.onReachabilityChange?(self.reachability, endpoint)
            }

            if self.isMonitoring {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + endpoint.interval, qos: .background, flags: []) { [weak self] in
                    self?.check(endpoint: endpoint)
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
