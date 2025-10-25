//
//  ChatSessionListItemView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatSessionListItemView: View {
    let chatSession: ChatSession
    
    var body: some View {
        VStack {
            Divider()
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
}
