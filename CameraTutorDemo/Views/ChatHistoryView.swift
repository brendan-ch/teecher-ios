//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI
import SwiftData

struct ChatHistoryView: View {
    var onDismiss: (() -> Void)?
    @Binding var selectedChatSession: ChatSession?
    
    @Query(sort: \ChatSession.updatedAt, order: .reverse)
    private var chatSessions: [ChatSession]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Spacer(minLength: 0) // pushes content down
                if chatSessions.isEmpty {
                    Text("No chat history.")
                } else {
                    ForEach(chatSessions) { chatSession in
                        Divider()
                        ChatSessionListButton(isSelected: selectedChatSession == chatSession, chatSession: chatSession) {
                            selectChatSession(chatSession)
                        }
                    }
                }
            }
            
            if !chatSessions.isEmpty {
                VStack(alignment: .leading) {
                    Button {
                        selectedChatSession = nil
                    } label: {
                        Text("New chat")
                    }
                    .buttonStyle(.glassProminent)
                    .padding(.horizontal)

                    Button(role: .destructive) {
                        selectedChatSession = nil
                        for session in chatSessions {
                            modelContext.delete(session)
                        }
                        try? modelContext.save()
                    } label: {
                        Text("Clear history")
                    }
                    .buttonStyle(.glass)
                    .padding(.horizontal)
                }
            }
        }
    }
    
    func selectChatSession(_ chatSession: ChatSession) {
        selectedChatSession = chatSession
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
}

#Preview {
    let schema = Schema([
        ChatSession.self,
        ChatMessage.self,
        Attachment.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: schema, configurations: [modelConfiguration])
    
    let chatSessionToSelect = ChatSession(
        title: "Sample chat 1",
        createdAt: .now,
        updatedAt: .now,
        messages: []
    )
    modelContainer.mainContext.insert(chatSessionToSelect)
    modelContainer.mainContext.insert(ChatSession(
        title: "Sample chat 2",
        createdAt: .now,
        updatedAt: .now,
        messages: []
    ))

    return ChatHistoryView(
        selectedChatSession: .constant(chatSessionToSelect)
    )
        .modelContainer(modelContainer)
}

