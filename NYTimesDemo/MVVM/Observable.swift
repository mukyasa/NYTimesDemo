//
//  NYObservable.swift
//  NYTimesDemo
//
//  Created by mukesh on 19/9/21.
//

import UIKit

class Observable<T> {
    private var _value: T!
    var value: T {
        get {
            return _value
        }
        set {
            _value = newValue
            valueChanged?(newValue)
        }
    }

    init(value: T) {
        _value = value
    }

    var valueChanged: ((T) -> Void)?
}
