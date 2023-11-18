//
//  FirstRecursiveActionCreator.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation
import Combine
import ReactiveRedux

enum Err: Error {
    case er
}

class FirstRecursiveActionCreator: RecursiveActionCreator {
    
    func observeActions(statePublisher: AnyPublisher<ChatState, Error>) -> AnyPublisher<ChatAction, Error> {
        statePublisher.compactMap { state -> ChatAction? in
            .sendMessage("")
        }.eraseToAnyPublisher()
       
    }
    
}
