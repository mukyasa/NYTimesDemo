//
//  NetworkService.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import UIKit

enum NetworkError: Error {
    case noDataOrError
    case badResponse
    case statusCodeError(statusCode: Int)
}

struct StatusCodeError: LocalizedError {
    let code: Int

    var errorDescription: String? {
        return "An error occurred communicating with the server. Please try again."
    }
}

protocol NetworkServiceProtocol {
    func dataTask<T: Model>(_ request: Requestable,
                            completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    let urlSession: URLSession
    let completionQueue: DispatchQueue

    init(urlSessionConfig: URLSessionConfiguration = URLSessionConfiguration.default, completionQueue: DispatchQueue = DispatchQueue.main) {
        self.completionQueue = completionQueue
        urlSession = URLSession(configuration: urlSessionConfig)
    }

    func dataTask<T: Model>(_ request: Requestable,
                            completion: @escaping (Result<T, Error>) -> Void) {
        let urlRequest = request.urlRequest()
        // Send the request
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            let result: Result<T, Error>

            if let error = error {
                // First, check if the network just returned an error
                result = .failure(error)
            } else if let error = self.error(from: response) {
                // Next, check if the status code was valid
                result = .failure(error)
            } else if let data = data {
                // Otherwise, let's try parsing the data
                do {
                    let decoder = JSONDecoder()
                    result = .success(try decoder.decode(T.self,
                                                         from: data))
                } catch {
                    result = .failure(error)
                }
            } else {
                result = .failure(NetworkError.noDataOrError)
            }

            self.completionQueue.async {
                completion(result)
            }
        }

        task.resume()
    }

    private func error(from response: URLResponse?) -> Error? {
        guard let response = response as? HTTPURLResponse else {
            return NetworkError.badResponse
        }
        let statusCode = response.statusCode
        if statusCode >= 200,
           statusCode <= 299 {
            return nil
        } else {
            return NetworkError.statusCodeError(statusCode: statusCode)
        }
    }
}
