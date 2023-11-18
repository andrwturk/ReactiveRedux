//
//  ChatRepository.swift
//  ReduxApp
//
//  Created by Andrii Turkin on 18.11.23.
//

import Foundation

class ChatRepository: ChatRepositoring {
    func fetchMessages() async -> [String] {
        [
            "Hey",
            "Hello"
        ]
    }
}
