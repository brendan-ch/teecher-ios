//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatHistoryView: View {
    var onDismiss: (() -> Void)?
    @Binding var selectedChatSessionID: UUID?
    @Binding var chatSessions: [ChatSession]
    
    private var orderedSessions: [ChatSession] {
        chatSessions.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Spacer(minLength: 0) // pushes content down
                if orderedSessions.isEmpty {
                    Text("No chat history.")
                } else {
                    ForEach(orderedSessions) { chatSession in
                        Divider()
                        ChatSessionListButton(
                            isSelected: selectedChatSessionID == chatSession.id,
                            chatSession: chatSession
                        ) {
                            selectChatSession(chatSession.id)
                        }
                    }
                }
            }
            
            if !orderedSessions.isEmpty {
                VStack(alignment: .leading) {
                    Button {
                        selectedChatSessionID = nil
                    } label: {
                        Text("New chat")
                    }
                    .buttonStyle(.glassProminent)
                    .padding(.horizontal)

                    Button(role: .destructive) {
                        selectedChatSessionID = nil
                        chatSessions.removeAll()
                    } label: {
                        Text("Clear history")
                    }
                    .buttonStyle(.glass)
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private func selectChatSession(_ id: UUID) {
        selectedChatSessionID = id
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
}

#Preview {
    ChatHistoryView(
        onDismiss: nil,
        selectedChatSessionID: .constant(nil),
        chatSessions: .constant([
            .init(
                title: "Sample chat 1",
                createdAt: .now,
                updatedAt: .now,
                messages: []
            ),
            .init(
                title: "Sample chat 2",
                createdAt: .now,
                updatedAt: .now,
                messages: []
            )
        ])
    )
}
