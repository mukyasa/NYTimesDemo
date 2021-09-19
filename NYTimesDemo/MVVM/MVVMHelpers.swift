//
//  MVVMHelpers.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import UIKit

enum ViewModelState {
    case idle
    case refreshData
    case reloadRowAt(indexPath: IndexPath)

    case loading
    case loadingComplete
    case loadingMore
    case loadingMoreComplete(newlyAddedFirstRow: IndexPath?,
                             newlyAddedLastRow: IndexPath?)

    case loadingError(error: Error?)
}

protocol ViewModelProtocol {
    var state: Observable<ViewModelState> { get set }
}

protocol ViewModelWithListProtocol: ViewModelProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsIn(section: Int) -> Int
    func viewModelForCellAt(section: Int, index: Int) -> UISubviewModelProtocol?
}

protocol ViewModelWithListWithLoadMoreProtocol: ViewModelWithListProtocol {
    var pageNumber: Int { get set }
    var allPagesLoadComplete: Bool { get set }

    func viewWillDisplayRowAt(index: IndexPath)
    func loadMore()
}

extension ViewModelWithListWithLoadMoreProtocol {
    func loadMore() {}
    func viewWillDisplayRowAt(index: IndexPath) {}
}

// UI model to configure content in a UITableviewCell/UICollectionViewCell/UIView
protocol UISubviewModelProtocol {
    init()
}

protocol UISubviewConfigureProtocol {
    func configureSubviewsContentWith(viewModel: UISubviewModelProtocol) // Provide a generic function
}
