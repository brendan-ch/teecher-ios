//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatView: View {
    var onDismiss: (() -> Void)?
    var session: ChatSession?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let session = session {
                    if session.messages.isEmpty {
                        Text("No messages")
                    } else {
                        ForEach(session.messages.sorted(by: <)) { message in
                            MessageView(message: message)
                        }
                    }
                } else {
                    Text("Select or start a chat to view messages.")
                }
            }
        }
        .defaultScrollAnchor(.bottom)
    }
    
    func submit() {
        // TODO: Send the query and the image to the server
    }
}


#Preview {
    ChatView(session: .init(
        title: "Sample chat",
        timestamp: .now,
        messages: [
            .sampleUserMessage,
            .sampleAssistantMessage,
        ]
    ))
}
