//
//  ArticleListService.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import UIKit

typealias ArticleCompletion = (_ articles: [Article]?, _ error: Error?) -> Void

protocol ArticleListServiceProtocol {
    func fetchArticles(completion: @escaping ArticleCompletion)
}

class ArticleListService: ArticleListServiceProtocol {
    let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchArticles(completion: @escaping ArticleCompletion) {
        let request = Request(path: "/svc/mostpopular/v2/viewed/7.json")
        networkService.dataTask(request) { (result: Result<ArticleResponse, Error>) in
            switch result {
            case let .success(value):
                completion(value.articles, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
}
