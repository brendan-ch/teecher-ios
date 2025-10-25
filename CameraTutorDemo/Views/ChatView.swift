//
//  ChatView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatView: View {
    var session: ChatSession
    
    @State private var query = ""
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(session.messages) { message in
                    MessageView(message: message)
                }
            }
        }
        
        TextField("Ask anything", text: $query)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
}

struct MessageView: View {
    var message: ChatMessage
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            
            VStack(alignment: .leading) {
                Text(message.role.rawValue)
                    .multilineTextAlignment(.leading)
                    .bold()
                Text(message.content)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatView(session: .init(
        title: "Sample chat",
        createdAt: .distantPast,
        updatedAt: .now,
        messages: [
            .init(
                content: "How do you solve this quadratic equation?",
                role: .user,
                timestamp: .distantPast
            ),
            .init(
                content: """
Let’s think this through step by step instead of jumping straight to the answer.

First, when you see a quadratic equation like 3x^2 - 5x + 2 = 0, what’s the general approach or formula that comes to mind for solving it?

There are a few ways — factoring, completing the square, or using the quadratic formula.

If factoring looks possible, we can look for two numbers that multiply to 3 \times 2 = 6 and add up to -5.

Can you think of two numbers that fit that description?
""",
                role: .assistant,
                timestamp: .now
            )
        ]
    ))
}
