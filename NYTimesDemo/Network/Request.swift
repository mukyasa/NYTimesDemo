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
    let params: [String: Any]

    init(path: String,
         method: String = "GET",
         params: [String: Any] = [:]) {
        self.path = path
        self.method = method
        self.params = params
    }

    func urlRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nytimes.com"
        components.path = path
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "api-key",
                                                        value: "Oxd75GsHDbtpHsOBoIpLZmPrATvSQLEz")]
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key,
                                         value: "\(value)")
            queryParams.append(queryItem)
        }
        components.queryItems = queryParams
        guard let url = components.url else {
            fatalError("URL Request building error")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        return urlRequest
    }
}
