//
//  ArticleModel.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import UIKit

struct Article: Model {
    struct ArticleMedia: Model {
        struct ArticleMediaData: Model {
            var imageURL: String?
            var width: Int?
            var height: Int?

            enum CodingKeys: String, CodingKey {
                case imageURL = "url"
                case width
                case height
            }
        }

        var mediaMetaData: [ArticleMediaData]?

        enum CodingKeys: String, CodingKey {
            case mediaMetaData = "media-metadata"
        }
    }

    var url: String?
    var title: String?
    var byLine: String?
    var publishedAt: String?
    var media: [ArticleMedia]?

    enum CodingKeys: String, CodingKey {
        case url
        case title
        case byLine = "byline"
        case media
        case publishedAt = "published_date"
    }
}

struct ArticleResponse: Model {
    var copyright: String?
    var numOfResults: Int?
    var articles: [Article]?

    enum CodingKeys: String, CodingKey {
        case copyright
        case numOfResults = "num_results"
        case articles = "results"
    }
}
