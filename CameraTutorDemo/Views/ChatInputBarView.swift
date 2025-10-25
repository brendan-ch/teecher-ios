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
        TextField("Ask anything", text: $query)
            .focused(keyboardFocused)
            .textFieldStyle(.roundedBorder)
            .padding(.bottom, keyboard.currentHeight)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            .onSubmit {
                submit(query)
            }
    }
}

