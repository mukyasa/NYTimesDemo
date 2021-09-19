//
//  UIViewControllerEx.swift
//  NYTimesDemo
//
//  Created by mukesh on 20/9/21.
//

import UIKit

extension UIViewController {
    func showMessage(_ msg: String) {
        let alertVC = UIAlertController(title: "NYTimes",
                                        message: msg,
                                        preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .cancel,
                                        handler: nil)
        alertVC.addAction(closeAction)
        present(alertVC,
                animated: true,
                completion: nil)
    }
}
