<p align="center">
  <a href="https://www.bitrise.io/app/cf986b7ccf2372bc"><img alt="Travis Status" src="https://www.bitrise.io/app/cf986b7ccf2372bc.svg?token=yxSjM7cJW-od880dyazf-g&branch=master"/></a>
  <a href="https://img.shields.io/cocoapods/v/Horizon.svg"><img alt="CocoaPods compatible" src="https://img.shields.io/cocoapods/v/Horizon.svg"/></a>
  <a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
</p>

#Horizon

**Horizon** is a µFramework written in Swift. It replaces the use of the Reachability part of Apple's System Configuration framework.

<p align="center">
    <a href="#usage">Usage</a> • <a href="#example">Example</a> • <a href="#installation">Installation</a> • <a href="#contact">Contact</a> • <a href="#license">License</a>
</p>

## Usage

Every endpoint can be configured with a custom timeout and interval between checking for reachability.

## Example

```swift

let horizon = Horizon()

//Called when overall reachability changes
horizon.onReachabilityChange = { reachability, _ in
    print("Reachability: \(reachability)") // prints Full, Partial or None
}

//Called every time a given endpoint has been checked
let endpointOnUpdate: (endpoint: Endpoint, didChangeReachable: Bool) -> () = { endpoint, reachabilityDidChange in
    let reachable = endpoint.isReachable ? "YES" : "NO"
    let formattedResponseTime = String(format: "%.2f", endpoint.responseTimes.last! * 1000)
    let formattedStandardDeviation = String(format: "%.2f", (endpoint.responseTimes.standardDeviation(isSample: true) ?? 0) * 1000)

    print("Endpoint: \(endpoint.url.absoluteString) reachable:\(reachable) response time: \(formattedResponseTime)ms standard deviation: \(formattedStandardDeviation)ms")
}

//Endpoint with default interval and timeout
if let endpointExample = Endpoint(urlString: "http://www.example.com", onUpdate: endpointOnUpdate) {
    horizon.add(endpointExample)
}

//Endpoint with custom interval and timeout
if let endpointGithub = Endpoint(urlString: "https://github.com", interval: 1, timeout: 3, onUpdate: endpointOnUpdate) {
    horizon.add(endpointGithub)
}

horizon.startMonitoring()

```

## Installation

### Carthage

To integrate Horizon into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "pisarm/Horizon"
```

### Cocoapods

To integrate Horizon into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

pod 'Horizon'
```

## Contact

Follow and contact me on [Twitter](http://twitter.com/pisarm). If you find an issue,
just [open a ticket](https://github.com/pisarm/Horizon/issues/new) on it.

## License

Copyright (c) 2016 Flemming Pedersen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
