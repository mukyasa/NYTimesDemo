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

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

extension ViewModelState: Equatable {
    public static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loadingComplete, .loadingComplete):
            return true
        case (.idle, .idle):
            return true
        case (.loadingMore, .loadingMore):
            return true
        case (.refreshData, .refreshData):
            return true
        case let (.loadingMoreComplete(newlyAddedFirstRow: lhsFirstRow,
                                       newlyAddedLastRow: lhsLastRow),
                  .loadingMoreComplete(newlyAddedFirstRow: rhsFirstRow,
                                       newlyAddedLastRow: rhsLastRow)):
            return lhsFirstRow == rhsFirstRow && lhsLastRow == rhsLastRow
        case let (.loadingError(error: lhsError),
                  .loadingError(error: rhsError)):
            return (lhsError.isNil && rhsError.isNil) || (!lhsError.isNil && !rhsError.isNil)
        default:
            return false
        }
    }
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
