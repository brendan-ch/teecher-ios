//
//  ChatMessage.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import SwiftData

@Model
final class ChatMessage {
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
