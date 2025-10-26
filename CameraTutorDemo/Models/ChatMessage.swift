//
//  ChatMessage.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation

struct ChatMessage: Identifiable, Equatable, Comparable, Codable {
    var id: String {
        content + timestamp.description
    }
    
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case role = "role"
        case timestamp = "timestamp"
        case hasImage = "has_image"
    }
    
    var content: String
    var role: Role
    var timestamp: Date
    var hasImage: Bool?
    
    init(
        content: String,
        role: Role,
        timestamp: Date
    ) {
        self.content = content
        self.role = role
        self.timestamp = timestamp
    }
    
    static func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.timestamp < rhs.timestamp
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
