//
//  RecursiveActionCreator.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation
import Combine

/// Create action to mutate state based on current state
public protocol RecursiveActionCreator {
    
    associatedtype StateType
    associatedtype ActionType
    
    func observeActions(statePublisher: AnyPublisher<StateType, Error>) -> AnyPublisher<ActionType, Error>
}

extension RecursiveActionCreator {
    
    /// Type erasure
    public func typeErased<ErasedStateType, ErasedActionType>() -> AnyRecursiveActionCreator<ErasedStateType, ErasedActionType> where ErasedActionType == ActionType, ErasedStateType == StateType {
        return AnyRecursiveActionCreator<StateType, ActionType>(wrappedActionCreator: self)
    }
    
}

/// Wrapping class for type erasure
public final class AnyRecursiveActionCreator<WrappedStateType, WrappedActionType>: RecursiveActionCreator {
   
    public typealias StateType = WrappedStateType
    public typealias ActionType = WrappedActionType
    
    private let wrappedObserveActions: (AnyPublisher<WrappedStateType, Error>) -> AnyPublisher<WrappedActionType, Error>
    
    init<WrappedActionCreator: RecursiveActionCreator>(wrappedActionCreator: WrappedActionCreator)
        where WrappedActionCreator.ActionType == WrappedActionType, WrappedStateType == WrappedActionCreator.StateType {
            wrappedObserveActions = { statePublisher in
                wrappedActionCreator.observeActions(statePublisher: statePublisher)
            }
    }
    
    public func observeActions(statePublisher: AnyPublisher<StateType, Error>) -> AnyPublisher<ActionType, Error> {
        return wrappedObserveActions(statePublisher)
    }
    
}

