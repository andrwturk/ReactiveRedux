//
//  SecondRecursiveActionCreator.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//


import Foundation
import Combine
import ReactiveRedux

class FetchMessagesActionCreator: ActionCreator {
    
    init(repository: ChatRepositoring) {
        self.repository = repository
    }
    
    private let repository: ChatRepositoring
    
    func observeActions() -> AnyPublisher<ChatAction, Error> {
        return Future<ChatAction, Error> { promise in
                Task {
                    do {
                        let messages = try await self.repository.fetchMessages()
                        promise(.success(.addMessageHistory(messages)))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
}
