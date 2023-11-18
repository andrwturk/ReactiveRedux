//
//  ActionCreator.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation
import Combine

/// Create actions independent of current Redux state

public protocol ActionCreator {
    
    associatedtype ActionType
    
    func observeActions() -> AnyPublisher<ActionType, Error>
}

extension ActionCreator {
    
    public func typeErased<ErasedActionType>() -> AnyActionCreator<ErasedActionType> where ErasedActionType == ActionType {
        return AnyActionCreator<ActionType>(wrappedActionCreator: self)
    }
    
}

/// Wrapping class for type erasure

public final class AnyActionCreator<WrappedActionType>: ActionCreator {
   
    public typealias ActionType = WrappedActionType
    
    private let wrappedObserveActions: () -> AnyPublisher<WrappedActionType, Error>
    
    init<WrappedActionCreator: ActionCreator>(wrappedActionCreator: WrappedActionCreator)
        where WrappedActionCreator.ActionType == WrappedActionType {
            wrappedObserveActions = { wrappedActionCreator.observeActions().eraseToAnyPublisher() }
    }
    
    public func observeActions() -> AnyPublisher<ActionType, Error> {
        return wrappedObserveActions()
    }
    
}
