//
//  MessageView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

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
    MessageView(message: .init(
        content: "Test message",
        role: .assistant,
        timestamp: .now,
    ))
}
