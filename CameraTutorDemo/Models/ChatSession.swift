//
//  ChatSession.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import SwiftData

@Model
class ChatSession {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade)
    var messages: [ChatMessage]
    
    @Transient
    var activeMessage: ChatMessage?
    
    init(id: UUID, createdAt: Date, updatedAt: Date, messages: [ChatMessage]) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.messages = messages
    }
}
