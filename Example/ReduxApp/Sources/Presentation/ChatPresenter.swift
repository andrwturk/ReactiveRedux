//
//  Presenter.swift
//  ReduxCombine
//
//  Created by Andrii Turkin on 10.11.23.
//

import Foundation
import Combine
import ReactiveRedux
    
class ChatPresenter: ObservableObject {
    
    @Published var chatStateItem: ChatViewStateItem = .loading
    
    private lazy var chatStateMachine = ChatStateMachine()
    
    private var cancellables = Set<AnyCancellable>()
    
    func bind() {
        chatStateMachine
            .observeState()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] state in
                self?.updateUI(with: state)
            })
            .store(in: &cancellables)
    }
    
    private func updateUI(with state: ChatState) {
        
        let messages = state.messages.map { message in
            ChatMessageViewItem(
                text: message,
                author: "D.",
                createdAt: Date()
            )
        }
        
        chatStateItem = .ok(ChatViewItem(messages: messages))
    }
    
    func addMessage(_ message: String) {
        chatStateMachine.dispatch(action: .sendMessage(message))
    }
}
