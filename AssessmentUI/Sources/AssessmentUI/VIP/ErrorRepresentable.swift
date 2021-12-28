//
//  ErrorRepresentable.swift
//  AssessmentUI
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation

public protocol ErrorRepresentable: Equatable {
    var localizedDescription: String { get }
    
    init(error: Error)
}

public struct GenericErrorRepresentable: ErrorRepresentable {
    public let localizedDescription: String
    
    public init(error: Error) {
        localizedDescription = error.localizedDescription
    }
}
