//
//  StoryboardEx.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import UIKit

enum UIStoryboardType: String {
    case main = "Main"
}

protocol StoryboardableInitProtocol {
    // ViewModel
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }

    // Methods
    static func instantiate(storyBoardName: UIStoryboardType) -> Self
    static func instantiate(with viewModel: Self.ViewModelType,
                            storyBoardName: UIStoryboardType) -> Self
}

protocol StoryboardableInitProtocolWithoutDependency {
    // Methods
    static func instantiate(storyBoardName: UIStoryboardType) -> Self
}

extension StoryboardableInitProtocol where Self: UIViewController {
    static func instantiate(storyBoardName: UIStoryboardType) -> Self {
        let storyboardId = String(describing: self)
        let viewController = UIStoryboard(name: storyBoardName.rawValue,
                                          bundle: nil).instantiateViewController(withIdentifier: storyboardId)
        guard let controller = viewController as? Self else {
            fatalError("Failed to instantiate '\(storyboardId)'")
        }
        return controller
    }

    static func instantiate(with viewModel: Self.ViewModelType,
                            storyBoardName: UIStoryboardType) -> Self {
        let storyboardId = String(describing: self)
        let viewController = UIStoryboard(name: storyBoardName.rawValue,
                                          bundle: nil).instantiateViewController(withIdentifier: storyboardId)
        guard var controller = viewController as? Self else {
            fatalError("Failed to instantiate '\(storyboardId)'")
        }
        controller.viewModel = viewModel
        return controller
    }
}

extension StoryboardableInitProtocolWithoutDependency where Self: UIViewController {
    static func instantiate(storyBoardName: UIStoryboardType) -> Self {
        let storyboardId = String(describing: self)
        let viewController = UIStoryboard(name: storyBoardName.rawValue,
                                          bundle: nil).instantiateViewController(withIdentifier: storyboardId)
        guard let vc = viewController as? Self else {
            fatalError("Failed to instantiate '\(storyboardId)'")
        }
        return vc
    }
}
