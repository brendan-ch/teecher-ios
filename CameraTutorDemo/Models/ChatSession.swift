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
    
    mutating func addChatResponseFromAssistant(
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
        self = decoded.session
    }
    
    static func == (lhs: ChatSession, rhs: ChatSession) -> Bool {
        lhs.id == rhs.id
    }
}
