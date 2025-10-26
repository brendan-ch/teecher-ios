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
        let requestUrl = URL.apiBaseUrl.appendingPathComponent("/api/new_session")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        let (data, _) = try await session.data(for: request)
        self = try JSONDecoder.decoderSupportingIso8601WithMicroseconds.decode(ChatSession.self, from: data)
    }
    
    /// If the session already exists on the server, use this initializer to create it.
    init(
        session: URLSession = URLSession.shared,
        id: String,
    ) async throws {
        let requestUrl = URL.apiBaseUrl.appendingPathComponent("/api/get_session/\(id)")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let (data, _) = try await session.data(for: request)
        self = try JSONDecoder.decoderSupportingIso8601WithMicroseconds.decode(ChatSession.self, from: data)
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
