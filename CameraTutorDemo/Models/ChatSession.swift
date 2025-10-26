import Foundation

struct ChatSession: Identifiable, Equatable {
    let id: String
    var title: String
    let createdAt: Date
    var updatedAt: Date
    var messages: [ChatMessage]
    
    init(
        id: String = UUID().uuidString,
        title: String,
        createdAt: Date,
        updatedAt: Date,
        messages: [ChatMessage]
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.messages = messages
    }
    
    /// Create a new session on the server.
    init(session: URLSession = URLSession.shared) async throws {
        // TODO: call the server
        self = .init(title: "", createdAt: .now, updatedAt: .now, messages: [])
    }
    
    /// If the session already exists on the server, use this initializer to create it.
    init(
        session: URLSession = URLSession.shared,
        id: String,
    ) async throws {
        self = .init(title: "", createdAt: .now, updatedAt: .now, messages: [])
    }
    
    func constructChatMessageFromAssistant(
        session: URLSession = .shared,
        userChatMessage: ChatMessage
    ) async throws -> ChatMessage {
        .init(
            content: "Test message",
            role: .assistant,
            timestamp: .now + 1
        )
    }
    
    static func == (lhs: ChatSession, rhs: ChatSession) -> Bool {
        lhs.id == rhs.id
    }
}
