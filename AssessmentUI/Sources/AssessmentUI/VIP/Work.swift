//
//  Work.swift
//  AssessmentUI
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation

public enum Work {
    
    public enum Model<FinishedValue, Error: Swift.Error> {
        case idle
        case active
        case failed(Error)
        case finished(FinishedValue)
    }
    
    public enum ViewModel<ERT: ErrorRepresentable>: Equatable {
        case idle
        case active
        case failed(ERT)
        case finished
        
        public var isActive: Bool {
            switch self {
            case .active:
                return true
                
            case .idle, .finished, .failed:
                return false
                
            }
        }
        
        public var failure: ERT? {
            switch self {
            case .idle, .active, .finished:
                return nil
                
            case .failed(let failed):
                return failed
                
            }
        }
        
        public init<FinishedValue, Error>(model: Model<FinishedValue, Error>) {
            switch model {
            case .idle:
                self = .idle
                
            case .finished:
                self = .finished
                
            case .active:
                self = .active
                
            case .failed(let error):
                self = .failed(ERT.init(error: error))
                
            }
        }
    }
    
}

extension Work.Model: Equatable where FinishedValue: Equatable, Error: Equatable { }
