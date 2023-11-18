//
//  ChatAction.swift
//  ReduxApp
//
//  Created by Andrii Turkin on 17.11.23.
//

import Foundation

enum ChatAction {
    case addMessageHistory([String])
    case sendMessage(String)
}
