//
//  ArticleListVM.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

protocol ArticleListVMProtocol: ViewModelWithListProtocol {
    var articles: [Article] { get set }
    var networkService: ArticleListServiceProtocol { get set }
    func loadArticles()
}

class ArticleListVM: ArticleListVMProtocol {
    var articles: [Article] = []
    var networkService: ArticleListServiceProtocol
    var numberOfSections: Int = 1
    var state: Observable<ViewModelState> = Observable(value: .idle)

    init(networkService: ArticleListServiceProtocol = ArticleListService()) {
        self.networkService = networkService
    }

    func numberOfRowsIn(section: Int) -> Int {
        articles.count
    }

    func viewModelForCellAt(section: Int,
                            index: Int) -> UISubviewModelProtocol? {
        var tvcCellModel = ArticleListTVCVM()
        let article = articles[index]
        tvcCellModel.title = article.title
        tvcCellModel.author = article.byLine
        tvcCellModel.image = article.media?.first?.mediaMetaData?.first?.imageURL
        tvcCellModel.publishedAt = article.publishedAt
        return tvcCellModel
    }

    func loadArticles() {
        self.state.value = .loading
        networkService.fetchArticles { [weak self] articles, error in
            guard let self = self else { return }
            if let error = error {
                self.state.value = .loadingError(error: error)
            } else if let articles = articles {
                self.articles = articles
                self.state.value = .loadingComplete
            }
        }
    }
}
