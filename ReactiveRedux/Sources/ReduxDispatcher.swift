//
//  ReduxDispatcher.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation
import Combine

/// Dispatches an action to be executed
public final class ReduxDispatcher<StateType, ActionType> {
    
    private let recursiveActionCreators: [AnyRecursiveActionCreator<StateType, ActionType>]
    private let actionCreators: [AnyActionCreator<ActionType>]
    private let actionSubject = PassthroughSubject<ActionType, Error>()
    
    /// - Parameters:
    ///    - recursiveActionCreator: Recursive action creators
    ///    - actionCreators: Action creators
    public init(
        recursiveActionCreators: [AnyRecursiveActionCreator<StateType, ActionType>],
        actionCreators: [AnyActionCreator<ActionType>]
    ) {
        self.recursiveActionCreators = recursiveActionCreators
        self.actionCreators = actionCreators
    }
    
    /// - Parameters:
    ///    - action: action to be dispatched
    public func dispatch(action: ActionType) {
        actionSubject.send(action)
    }
    
    private func mergedRecursiveActionCreatorsActions(statePublisher: AnyPublisher<StateType, Error>) -> AnyPublisher<ActionType, Error> {
        return Publishers.MergeMany(recursiveActionCreators.map { actionCreator in
            actionCreator.observeActions(statePublisher: statePublisher)
        })
        .eraseToAnyPublisher()
    }
    
    private func mergeActionCreators() -> AnyPublisher<ActionType, Error> {
        return Publishers.MergeMany(actionCreators.map { actionCreator in
            actionCreator.observeActions()
        })
        .eraseToAnyPublisher()
    }
    
    func observeAction(statePublisher: AnyPublisher<StateType, Error>) -> AnyPublisher<ActionType, Error> {
        return Publishers.Merge3(
            actionSubject.eraseToAnyPublisher(),
            mergedRecursiveActionCreatorsActions(statePublisher: statePublisher),
            mergeActionCreators()
        )
        .eraseToAnyPublisher()
    }
    
}
