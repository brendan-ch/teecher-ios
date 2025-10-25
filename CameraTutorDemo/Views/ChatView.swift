//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatView: View {
    var session: ChatSession?
    var numberOfMessagesToDisplay: Int? = nil
    
    var messages: [ChatMessage] {
        if let numberOfMessagesToDisplay = numberOfMessagesToDisplay {
            return Array(session?.messages.prefix(upTo: numberOfMessagesToDisplay) ?? [])
        } else {
            return session?.messages ?? []
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let session = session {
                    if session.messages.isEmpty {
                        Text("No messages")
                    } else {
                        ForEach(messages) { message in
                            MessageView(message: message)
                        }
                    }
                } else {
                    Text("Select or start a chat to view messages.")
                }
            }
        }
    }
    
    func submit() {
        // TODO: Send the query and the image to the server
    }
}


#Preview {
    ChatView(session: .init(
        title: "Sample chat",
        createdAt: .distantPast,
        updatedAt: .now,
        messages: [
            .sampleUserMessage,
            .sampleAssistantMessage,
        ]
    ))
}
