//
//  PublisherExtension.swift
//  AssessmentUI
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Combine

public extension Publisher where Failure == Never {
    
    func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>, on object: T) -> AnyCancellable {
        return sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
    
}
