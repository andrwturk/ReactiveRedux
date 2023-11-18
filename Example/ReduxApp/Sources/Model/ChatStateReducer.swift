//
//  ChatStateReducer.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation

final class ChatStateReducer {
    static func invoke(state: ChatState,
                       action: ChatAction) -> ChatState {
        switch action {

        case .sendMessage(let message):
            return ChatState(messages: state.messages + [message])
            
        case .addMessageHistory(let messages):
            return ChatState(messages: state.messages + messages) 
        }
    }
}
