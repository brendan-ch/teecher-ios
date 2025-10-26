//
//  RecentChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct RecentChatView: View {
    var session: ChatSession
    let numMessagesToDisplay = 2
    
    var messages: [ChatMessage] {
        let messages = session.messages.sorted(by: <)
        let startIndex = max(messages.count - numMessagesToDisplay, 0)
        return Array(messages.suffix(from: startIndex))
    }

    
    var body: some View {
        if session.messages.isEmpty {
            Text("No messages")
        } else {
            ForEach(messages) { message in
                MessageView(message: message)
            }
        }
    }
}

#Preview {
    RecentChatView(
        session: .init(
            title: "Test session",
            createdAt: .distantPast,
            updatedAt: .now,
            messages: [
                .sampleUserMessage,
                .sampleAssistantMessage
            ]
        )
    )
}
