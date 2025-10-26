import Foundation

/// What is returned by `/api/send_message`.
struct ChatSessionResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case session = "session"
        case shouldRestart = "should_restart"
        case success = "success"
    }
    
    let session: ChatSession
    let shouldRestart: Bool
    let success: Bool
}

@Observable
class ChatSession: Identifiable, Equatable, Codable {
    let id: String
    var title: String?
    var timestamp: Date
    var messages: [ChatMessage]
    
    enum CodingKeys: String, CodingKey {
        // To make it work with Observable, we need to map to underlying properties
        case _timestamp = "timestamp"
        case _messages = "messages"
        case _title = "title"
        case id = "id"
    }
    
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
    static func create(session: URLSession = URLSession.shared) async throws -> ChatSession {
        let requestUrl = URL.apiBaseUrl.appendingPathComponent("/api/new_session")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        let (data, _) = try await session.data(for: request)
        let decoded = try JSONDecoder.decoderSupportingIso8601WithMicroseconds.decode(ChatSession.self, from: data)
        return decoded
    }
    
    /// If the session already exists on the server, use this initializer to create it.
    static func creat(
        session: URLSession = URLSession.shared,
        id: String,
    ) async throws -> ChatSession {
        let requestUrl = URL.apiBaseUrl.appendingPathComponent("/api/get_session/\(id)")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder.decoderSupportingIso8601WithMicroseconds.decode(ChatSession.self, from: data)
    }
    
    func addChatResponseFromAssistant(
        session: URLSession = .shared,
        userChatMessage: ChatMessage,
        attachment: JPEGAttachment?,
    ) async throws {
        messages.append(userChatMessage)
        
        let requestUrl = URL.apiBaseUrl.appendingPathComponent("/api/send_message")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        var requestBodyDict = [
            "session_id": self.id,
            "message": userChatMessage.content
        ]
        if let attachment = attachment,
           let base64Encoded = try attachment.loadDataAsBase64() {
            requestBodyDict["image"] = base64Encoded
        }
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBodyDict)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await session.data(for: request)
        let decoded = try JSONDecoder.decoderSupportingIso8601WithMicroseconds.decode(ChatSessionResponse.self, from: data)
        self.messages = decoded.session.messages
    }
    
    static func == (lhs: ChatSession, rhs: ChatSession) -> Bool {
        lhs.id == rhs.id
    }
}
