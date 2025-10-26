//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatHistoryView: View {
    var onDismiss: (() -> Void)?
    @Environment(ChatProvider.self) private var chatProvider
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Spacer(minLength: 0) // pushes content down
                if chatProvider.sortedChatSessions.isEmpty {
                    Text("No chat history.")
                } else {
                    ForEach(chatProvider.sortedChatSessions) { chatSession in
                        Divider()
                        ChatSessionListButton(
                            isSelected: chatProvider.selectedChatSessionID == chatSession.id,
                            chatSession: chatSession
                        ) {
                            selectChatSession(chatSession.id)
                        }
                    }
                }
            }
            
            if !chatProvider.sortedChatSessions.isEmpty {
                VStack(alignment: .leading) {
                    Button {
                        chatProvider.selectChatSession(nil)
                    } label: {
                        Text("New chat")
                    }
                    .buttonStyle(.glassProminent)
                    .padding(.horizontal)

                    Button(role: .destructive) {
                        chatProvider.clearHistory()
                    } label: {
                        Text("Clear history")
                    }
                    .buttonStyle(.glass)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            Task {
                await chatProvider.loadSessionsFromServer()
            }
        }
    }
    
    private func selectChatSession(_ id: String) {
        chatProvider.selectChatSession(id)
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
}

#Preview {
    let provider = ChatProvider()
    provider.chatSessions = [
        .init(
            title: "Sample chat 1",
            timestamp: .now,
            messages: []
        ),
        .init(
            title: "Sample chat 2",
            timestamp: .now,
            messages: []
        )
    ]
    return ChatHistoryView(
        onDismiss: nil
    )
    .environment(provider)
}
