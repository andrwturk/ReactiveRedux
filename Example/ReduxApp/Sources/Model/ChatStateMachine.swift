//
//  ChatStateMachine.swift
//  ReduxApp
//
//  Created by Andrii Turkin on 18.11.23.
//

import Foundation
import ReactiveRedux
import Combine

final class ChatStateMachine {
    
    lazy var repository = ChatRepository()

    lazy var dispatcher = ReduxDispatcher<ChatState, ChatAction>(recursiveActionCreators: [],
                    actionCreators: [
                        FetchMessagesActionCreator(repository: repository).typeErased()
                    ])
    
    private let actionsScheduler = DispatchQueue(
        label: "action_queue", qos: .userInitiated)

    private lazy var storage = StateStorage(
        initialState: ChatState(),
        reduxDispatcher: dispatcher,
        actionsScheduler: actionsScheduler,
        reducer: ChatStateReducer.invoke(state:action:))
    
    func dispatch(action: ChatAction) {
        storage.reduxDispatcher.dispatch(action: action)
    }
    
    func observeState() -> AnyPublisher<ChatState, Error> {
        storage.observeState()
    }
}
