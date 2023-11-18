//
//  SecondRecursiveActionCreator.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//


import Foundation
import Combine
import ReactiveRedux

class FetchMessagesActionCreator: RecursiveActionCreator {
    
    func observeActions(statePublisher: AnyPublisher<ChatState, Error>) -> AnyPublisher<ChatAction, Error> {
        return Empty<ChatAction, Error>(completeImmediately: true)
                    .eraseToAnyPublisher()
    }
    
}
