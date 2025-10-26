//
//  CameraTutorDemoApp.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

@main
struct CameraTutorDemoApp: App {
    @State private var chatProvider = ChatProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(chatProvider)
        }
    }
}
