//
//  ChatMessage.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import SwiftData

@Model
final class ChatMessage: Comparable {
    static func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
    
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }
    
    var id: UUID
    var content: String
    var role: Role
    var attachments: [Attachment]?
    var timestamp: Date
    
    @Relationship(inverse: \ChatSession.messages)
    var session: ChatSession?
    
    init(id: UUID = UUID(), content: String, role: Role, attachments: [Attachment]? = nil, timestamp: Date) {
        self.id = id
        self.content = content
        self.role = role
        self.attachments = attachments
        self.timestamp = timestamp
    }
}

extension ChatMessage {
    static var sampleUserMessage: ChatMessage {
        .init(
            content: "How do you solve this quadratic equation?",
            role: .user,
            timestamp: .distantPast
        )
    }
    
    static var sampleAssistantMessage: ChatMessage {
        .init(
            content: """
Let’s think this through step by step instead of jumping straight to the answer.

First, when you see a quadratic equation like 3x^2 - 5x + 2 = 0, what’s the general approach or formula that comes to mind for solving it?

There are a few ways — factoring, completing the square, or using the quadratic formula.

If factoring looks possible, we can look for two numbers that multiply to 3 \times 2 = 6 and add up to -5.

Can you think of two numbers that fit that description?
""",
            role: .assistant,
            timestamp: .now
        )
    }
}
