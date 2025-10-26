import Foundation

struct ChatSession: Identifiable, Equatable {
    let id: UUID
    var title: String
    let createdAt: Date
    var updatedAt: Date
    var messages: [ChatMessage]
    
    init(
        id: UUID = UUID(),
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
