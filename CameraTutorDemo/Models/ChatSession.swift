import Foundation

struct ChatSession: Identifiable, Equatable, Codable {
    let id: String
    var title: String?
    var timestamp: Date
    var messages: [ChatMessage]
    
    init(
        id: String = UUID().uuidString,
        title: String?,
        timestamp: Date,
        messages: [ChatMessage]
    ) {
        self.id = id
        self.title = title
        self.timestamp = timestamp
        self.messages = messages
    }
    
    /// Create a new session on the server.
    init(session: URLSession = URLSession.shared) async throws {
        var request = URLRequest(url: .apiBaseUrl)
        request.httpMethod = "POST"
        
        let (data, response) = try await session.data(for: request)
        
        
        // TODO: call the server
        self = .init(title: "", timestamp: .now, messages: [])
    }
    
    /// If the session already exists on the server, use this initializer to create it.
    init(
        session: URLSession = URLSession.shared,
        id: String,
    ) async throws {
        self = .init(title: "", timestamp: .now, messages: [])
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
