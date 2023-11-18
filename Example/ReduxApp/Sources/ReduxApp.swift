//
//  ReduxAppApp.swift
//  ReduxApp
//
//  Created by Andrii Turkin on 17.11.23.
//

import SwiftUI

@main
struct ReduxApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView(presenter: ChatPresenter())
        }
    }
}
