//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI
import SwiftData

struct ChatHistoryView: View {
    @Query(sort: \ChatSession.updatedAt, order: .reverse)
    private var chatSessions: [ChatSession]
    
    @Environment(\.modelContext) var modelContext
    
    @State private var query = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Chats")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            
            if chatSessions.isEmpty {
                Text("No chat history.")
            } else {
                ForEach(chatSessions) { chatSession in
                    ChatSessionListButton(chatSession: chatSession) {
                        // navigate to the chat
                    }
                }
            }
            
            TextField("New chat", text: $query)
                .textFieldStyle(.roundedBorder)
                .padding()
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
    
    modelContainer.mainContext.insert(ChatSession(
        title: "Sample chat 1",
        createdAt: .now,
        updatedAt: .now,
        messages: []
    ))
    modelContainer.mainContext.insert(ChatSession(
        title: "Sample chat 2",
        createdAt: .now,
        updatedAt: .now,
        messages: []
    ))

    return ChatHistoryView()
        .modelContainer(modelContainer)
}

