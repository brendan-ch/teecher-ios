//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI
import SwiftData

struct ChatHistoryView: View {
    @Binding var selectedChatSession: ChatSession?
    
    @Query(sort: \ChatSession.updatedAt, order: .reverse)
    private var chatSessions: [ChatSession]
    
    @Environment(\.modelContext) var modelContext
    
    @State private var query = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                Spacer(minLength: 0) // pushes content down
                if chatSessions.isEmpty {
                    Text("No chat history.")
                } else {
                    ForEach(chatSessions) { chatSession in
                        ChatSessionListButton(chatSession: chatSession) {
                            selectedChatSession = chatSession
                        }
                    }
                }
            }
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

    return ChatHistoryView(selectedChatSession: .constant(chatSessionToSelect))
        .modelContainer(modelContainer)
}

