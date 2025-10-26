//
//  ChatInputBarView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ChatInputBarView: View {
    @State var query: String = ""
    var keyboardFocused: FocusState<Bool>.Binding
    var submit: (_ text: String) -> Void
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        HStack {
            TextField("Ask anything", text: $query)
                .focused(keyboardFocused)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    submit(query)
                    query = ""
                }
            
            Button {
                submit(query)
                query = ""
            } label: {
                Text("Send")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.bottom, keyboard.currentHeight)
        .padding()
        .padding(EdgeInsets(top: 0, leading: 0, bottom: keyboardFocused.wrappedValue ? 0 : 32, trailing: 0))
    }
}

