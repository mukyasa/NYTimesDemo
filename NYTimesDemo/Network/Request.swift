//
//  Rewquest.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import Foundation

/* A protocol to wrap request objects. This gives us a better API over URLRequest.*/
protocol Requestable {
    /**
     Generates a URLRequest from the request. This will be run on a background thread so model parsing is allowed.
     */
    func urlRequest() -> URLRequest
}

/**
 A simple request with no post data.
 */
struct Request: Requestable {
    let path: String
    let method: String

    init(path: String,
         method: String = "GET") {
        self.path = path
        self.method = method
    }

    func urlRequest() -> URLRequest {
        guard let url = URL(string: path) else {
            fatalError("URL Request building error")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        return urlRequest
    }
}
