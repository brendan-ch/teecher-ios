//
//  ChatSessionListItemView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatSessionListButton: View {
    let isSelected: Bool
    let chatSession: ChatSession
    let action: @MainActor () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(chatSession.title)
                            .bold()
                        Text(chatSession.updatedAt.formatted(date: .numeric, time: .shortened))
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .tint(isSelected ? .accentColor : .primary)
    }
}

#Preview {
    ChatSessionListButton(
        isSelected: false,
        chatSession: .init(
            title: "Sample chat",
            createdAt: .distantPast,
            updatedAt: .now,
            messages: []
        ),
        action: {
            print("Pressed")
        }
    )
}
