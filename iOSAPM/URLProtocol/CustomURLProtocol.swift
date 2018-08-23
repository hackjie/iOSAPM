//
//  CustomURLProtocol.swift
//  iOSAPM
//
//  Created by leoli on 2018/8/23.
//  Copyright © 2018 leoli. All rights reserved.
//

import UIKit
import Alamofire

class CustomURLProtocol: URLProtocol {

    struct PropertyKeys {
        static let handledByForwarderURLProtocol = "HandledByProxyURLProtocol"
    }

    lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

            return configuration
        }()

        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

        return session
    }()

    var activeTask: URLSessionTask?

    // MARK: Class Request Methods
    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: PropertyKeys.handledByForwarderURLProtocol, in: request) != nil {
            return false
        }

        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        if let headers = request.allHTTPHeaderFields {
            do {
                return try URLEncoding.default.encode(request, with: headers)
            } catch {
                return request
            }
        }

        return request
    }

    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    // MARK: Loading Methods
    override func startLoading() {
        let urlRequest = (request.urlRequest! as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: PropertyKeys.handledByForwarderURLProtocol, in: urlRequest)
        activeTask = session.dataTask(with: urlRequest as URLRequest)
        activeTask?.resume()
    }

    override func stopLoading() {
        activeTask?.cancel()
    }
}

extension CustomURLProtocol: URLSessionDataDelegate {
    // MARK: NSURLSessionDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let response = task.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        client?.urlProtocolDidFinishLoading(self)
    }
}
