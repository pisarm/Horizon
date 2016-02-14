//
//  Horizon.swift
//  Horizon
//
//  Created by Flemming Pedersen on 11/02/16.
//  Copyright © 2016 pisarm.dk. All rights reserved.
//

import Foundation

public class Host {
    var isReachable: Bool = false
    var responseCode: Int = 0
    var responseTime: NSTimeInterval {
        return responseTimes.last ?? 0
    }
    var meanResponseTime: NSTimeInterval {
        return responseTimes.reduce(0.0, combine: +) / Double(responseTimes.count)
    }

    var responseTimes: PurgingArray<NSTimeInterval> = PurgingArray()
    var url: NSURL
    let action: (host: Host) -> ()

    init(urlString: String, action: (host: Host) -> ()) {
        self.url = NSURL(string: urlString)!
        self.action = action
    }
}

public final class Horizon {
    //MARK:
    public private(set) var hosts: [Host] = []
    private let urlSession: URLSessionProtocol

    public init(urlSession: URLSessionProtocol = Horizon.defaultSession()) {
        self.urlSession = urlSession
    }

    public func add(urlString: String, action: (host: Host) -> ()) {
        let host = Host(urlString: urlString, action: action)
        hosts.append(host)
    }

    public func remove(urlString: String) {
        hosts = hosts.filter { $0.url.absoluteString != urlString }
    }

    public func start() {
        let dispatchGroup = dispatch_group_create()

        hosts.forEach { host in
            dispatch_group_enter(dispatchGroup)

            let beginTime = NSDate.timeIntervalSinceReferenceDate()

            urlSession.dataTaskWithURL(host.url) { data, response, error in
                if error != nil {
                    host.isReachable = false
                    host.action(host: host)
                } else {
                    if let httpURLResponse = response as? NSHTTPURLResponse {
                        host.responseCode = httpURLResponse.statusCode
                    }
                    host.isReachable = true
                    host.responseTimes.append(NSDate.timeIntervalSinceReferenceDate() - beginTime)
                    host.action(host: host)
                }

                dispatch_group_leave(dispatchGroup)

                }.resume()
        }

        dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [unowned self] in
            self.start()
        }
    }
}

private extension Horizon {
    private static func defaultSession() -> NSURLSession {
        let urlSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSessionConfiguration.timeoutIntervalForRequest = 1.0
        urlSessionConfiguration.timeoutIntervalForResource = 1.0

        return NSURLSession(configuration: urlSessionConfiguration)
    }
}
