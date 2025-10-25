//
//  CameraTutorDemoApp.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI
import SwiftData

@main
struct CameraTutorDemoApp: App {
    @State private var modelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: ChatSession.self, ChatMessage.self, Attachment.self)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
