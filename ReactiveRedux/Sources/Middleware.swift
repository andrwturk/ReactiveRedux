//
//  Middleware.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation
import Combine

/// Perform side effects on state changes
public protocol Middleware {
    associatedtype StateType
    associatedtype ActionType
    
    func on(newState: StateType)
    func on(oldState: StateType, newState: StateType, action: ActionType)
    func before(action: ActionType)
}

extension Middleware {
    public func on(newState: StateType) {}
    public func on(oldState: StateType, newState: StateType, action: ActionType) {}
    public func before(action: ActionType) {}
}

extension Middleware {
    public func typeErased<ErasedStateType, ErasedActionType>() -> AnyMiddleware<ErasedStateType, ErasedActionType> where ErasedActionType == ActionType, ErasedStateType == StateType {
        return AnyMiddleware<StateType, ActionType>(wrappedMiddleware: self)
    }
}

/// Wrapping class for type erasure
public final class AnyMiddleware<WrappedStateType, WrappedActionType>: Middleware {
    
    public typealias StateType = WrappedStateType
    public typealias ActionType = WrappedActionType
    
    private let beforeActionClosure: (WrappedActionType) -> Void
    private let onNewStateClosure: (WrappedStateType) -> Void
    private let onOldStateNewStateClosure: (WrappedStateType, WrappedStateType, WrappedActionType) -> Void
    
    init<WrappedMiddleware: Middleware>(wrappedMiddleware: WrappedMiddleware)
        where WrappedMiddleware.ActionType == WrappedActionType, WrappedStateType == WrappedMiddleware.StateType {
            onNewStateClosure = { state in
                wrappedMiddleware.on(newState: state)
            }
            
            onOldStateNewStateClosure = { oldState, newState, action in
                wrappedMiddleware.on(oldState: oldState, newState: newState, action: action)
            }
            
            beforeActionClosure = { action in
                wrappedMiddleware.before(action: action)
            }
    }
    
    public func on(newState: WrappedStateType) {
        onNewStateClosure(newState)
    }
    
    public func on(oldState: WrappedStateType, newState: WrappedStateType, action: WrappedActionType) {
        onOldStateNewStateClosure(oldState, newState, action)
    }
    
    public func before(action: WrappedActionType) {
        beforeActionClosure(action)
    }
}

