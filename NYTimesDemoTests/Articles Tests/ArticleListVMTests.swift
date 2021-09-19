//
//  ArticleListVMTests.swift
//  NYTimesDemoTests
//
//  Created by mukesh on 20/9/21.
//

import XCTest

@testable import NYTimesDemo
class ArticleListVMTests: XCTestCase {
    var session: URLSessionMock!
    var networkService: ArticleListServiceProtocol!
    var viewModel: ArticleListVMProtocol!

    override func setUp() {
        super.setUp()
        session = URLSessionMock()
        let networkHelper = NetworkService(urlSession: session)
        networkService = ArticleListService(networkService: networkHelper)
        viewModel = ArticleListVM(networkService: networkService)
    }

    override func tearDown() {
        super.tearDown()
        session = nil
        networkService = nil
        viewModel = nil
    }

    func testViewModeIsNonEmpty() {
        let json = """
        {
          "status": "OK",
          "copyright": "Copyright (c) 2021 The New York Times Company.  All Rights Reserved.",
          "num_results": 20,
          "results": [
            {
              "uri": "nyt://article/a092ddca-cf99-5640-8a61-f0b77c052703",
              "url": "https://www.nytimes.com/2021/09/11/us/9-11-photos-images.html",
              "id": 100000007941764,
              "asset_id": 100000007941764,
              "source": "New York Times",
              "published_date": "2021-09-11",
              "updated": "2021-09-13 04:19:17",
              "section": "U.S.",
              "subsection": "",
              "nytdsection": "u.s.",
              "adx_keywords": "September 11 (2001);World Trade Center (Manhattan, NY);Photography;Funerals and Memorials;Fires and Firefighters;New York Times",
              "column": null,
              "byline": "By The New York Times",
              "type": "Article",
              "title": "The Photographs of 9/11",
              "abstract": "Photographers reflect on shooting the terrorist attacks of 9/11 and their aftermath.",
              "des_facet": [
                "September 11 (2001)",
                "World Trade Center (Manhattan, NY)",
                "Photography",
                "Funerals and Memorials",
                "Fires and Firefighters"
              ],
              "org_facet": [
                "New York Times"
              ],
              "per_facet": [],
              "geo_facet": [],
              "media": [
                {
                  "type": "image",
                  "subtype": "photo",
                  "caption": "",
                  "copyright": "Krista Niles/The New York Times",
                  "approved_for_syndication": 1,
                  "media-metadata": [
                    {
                      "url": "https://static01.nyt.com/images/2021/09/12/multimedia/00anniv911-photoreflections7/00anniv911-photoreflections7-thumbStandard.jpg",
                      "format": "Standard Thumbnail",
                      "height": 75,
                      "width": 75
                    },
                    {
                      "url": "https://static01.nyt.com/images/2021/09/12/multimedia/00anniv911-photoreflections7/merlin_193347993_e4b17ec5-5041-4038-bdd0-243f9f5dc418-mediumThreeByTwo210.jpg",
                      "format": "mediumThreeByTwo210",
                      "height": 140,
                      "width": 210
                    },
                    {
                      "url": "https://static01.nyt.com/images/2021/09/12/multimedia/00anniv911-photoreflections7/merlin_193347993_e4b17ec5-5041-4038-bdd0-243f9f5dc418-mediumThreeByTwo440.jpg",
                      "format": "mediumThreeByTwo440",
                      "height": 293,
                      "width": 440
                    }
                  ]
                }
              ],
              "eta_id": 0
            }
          ]
        }
        """
        let data = Data(json.utf8)
        session.data = data
        viewModel.loadArticles()
        XCTAssertEqual(viewModel.numberOfRowsIn(section: 1), 1)
        XCTAssertEqual(viewModel.state.value, ViewModelState.loadingComplete)
    }

    func testViewModeIsEmpty() {
        let error = NetworkError.badResponse
        session.error = error
        viewModel.loadArticles()
        XCTAssertEqual(viewModel.numberOfRowsIn(section: 1), 0)
        XCTAssertEqual(viewModel.state.value, ViewModelState.loadingError(error: error))
    }
}
