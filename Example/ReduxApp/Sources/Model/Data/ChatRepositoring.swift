//
//  ChatRepositoring.swift
//  ReduxApp
//
//  Created by Andrii Turkin on 18.11.23.
//

import Foundation

protocol ChatRepositoring {
    func fetchMessages() async throws -> [String]
}
