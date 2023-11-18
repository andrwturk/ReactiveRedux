//
//  StateStorage.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation
import Combine

/// Storing redux state
public final class StateStorage<StateType, StateActionType> {
    
    public let reduxDispatcher: ReduxDispatcher<StateType, StateActionType>
    
    private let initialState: StateType
    private let stateSubject: CurrentValueSubject<StateType, Error>
    private let reducer: (StateType, StateActionType) -> StateType
    private let actionsScheduler: DispatchQueue
    private let middlewares: [AnyMiddleware<StateType, StateActionType>]
    
    private var currentState: StateType {
        return stateSubject.value
    }
    
    private lazy var statePublisher: AnyPublisher<StateType, Error> = {
        return reduxDispatcher
            .observeAction(statePublisher: stateSubject.eraseToAnyPublisher())
            .receive(on: actionsScheduler)
            .handleEvents(receiveOutput: { [unowned self] action in
                self.middlewares.forEach { middleware in
                    middleware.before(action: action)
                }
            })
            .map { [unowned self] action in
                let oldState = self.currentState
                let newState = self.reducer(oldState, action)
                self.middlewares.forEach { middleware in
                    middleware.on(oldState: oldState, newState: newState, action: action)
                }
                
                return newState
            }
            .handleEvents(receiveOutput: { [unowned self] newState in
                self.middlewares.forEach { middleware in
                    middleware.on(newState: newState)
                }
                
                self.stateSubject.send(newState)
            })
            .prepend(currentState)
            .share()
            .eraseToAnyPublisher()
    }()
    
    /// - Parameters:
    ///   - initialState: A state to initialize the storage
    ///   - reduxDispatcher: Redux dispatcher
    ///   - actionsScheduler: Reactive scheduler
    ///   - middlewares: Redux middlewares to react to states
    public init(
        initialState: StateType,
        reduxDispatcher: ReduxDispatcher<StateType, StateActionType>,
        actionsScheduler: DispatchQueue,
        middlewares: [AnyMiddleware<StateType, StateActionType>] = [],
        reducer: @escaping (StateType, StateActionType) -> StateType
    ) {
        self.initialState = initialState
        self.reduxDispatcher = reduxDispatcher
        self.stateSubject = CurrentValueSubject(initialState)
        self.reducer = reducer
        self.actionsScheduler = actionsScheduler
        self.middlewares = middlewares
    }
    
    /// - Returns: A state to be observed by third parties
    public func observeState() -> AnyPublisher<StateType, Error> {
        return statePublisher
    }
    
}

