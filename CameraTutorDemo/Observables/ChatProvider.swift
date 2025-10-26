//
//  ChatProvider.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation

/// Central provider of all chats.
@MainActor
@Observable
class ChatProvider {
    /// All chat sessions the user has created during this run.
    var chatSessions: [ChatSession] = []
    var sortedChatSessions: [ChatSession] {
        chatSessions.sorted { $0.timestamp > $1.timestamp }
    }

    /// The identifier of the currently selected chat session.
    var selectedChatSessionID: String?

    /// Convenience accessor for the currently selected chat session.
    var selectedChatSession: ChatSession? {
        guard let selectedChatSessionID else { return nil }
        return chatSessions.first { $0.id == selectedChatSessionID }
    }

    /// Selects an existing chat session.
    func selectChatSession(_ id: String?) {
        selectedChatSessionID = id
    }

    /// Clears all locally stored chat sessions.
    func clearHistory() {
        selectedChatSessionID = nil
        chatSessions.removeAll()
    }

    /// Submit a user query, optionally with an image attachment captured from the camera.
    func submit(_ query: String, capturedImageData: Data?) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let userChatMessage = ChatMessage(
            content: query,
            role: .user,
            timestamp: .now
        )

        var attachment: JPEGAttachment?
        if let capturedImageData {
            do {
                var image = JPEGAttachment(name: "image-to-be-uploaded", type: .image)
                try image.save(data: capturedImageData, fileExtension: "jpg")
                attachment = image
            } catch {
                print("Unable to save image attachment: \(error)")
            }
        }

        do {
            let sessionIndex = try await ensureSelectedSession()
            let session = chatSessions[sessionIndex]
            session.timestamp = .now

            try await session.addChatResponseFromAssistant(
                userChatMessage: userChatMessage,
                attachment: attachment
            )
        } catch {
            print("Failed to submit chat message: \(error)")
        }
    }

    /// Ensures a session exists for the current selection, creating one if needed.
    private func ensureSelectedSession() async throws -> Int {
        if
            let selectedChatSessionID,
            let existingIndex = chatSessions.firstIndex(where: { $0.id == selectedChatSessionID })
        {
            return existingIndex
        }

        let newSession = try await ChatSession.create()
        chatSessions.append(newSession)
        selectedChatSessionID = newSession.id
        return chatSessions.count - 1
    }
}
