//
//  ChatSessionTests.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import Testing
@testable import CameraTutorDemo

@MainActor
class ChatSessionTests {
    @Test("Test that JSON from server decodes correctly")
    func testValidJsonDecoding() async throws {
        let validJsonData = """
            {
                "id": "session_1761441033386",
                "timestamp": "2025-10-25T18:10:33.386388",
                "messages": [
                    {
                        "role": "user",
                        "content": "Can you help me with this?",
                        "timestamp": "2025-10-25T18:10:33.650619",
                        "has_image": true
                    },
                    {
                        "role": "assistant",
                        "content": "Okay! I see you're working on finding the area of a circle with radius r = 3.\\n\\nTo start, do you remember the formula for the area of a circle?\\n",
                        "timestamp": "2025-10-25T18:10:36.198347"
                    }
                ]
            }
            """.data(using: .utf8)!
        
        let result = try JSONDecoder.decoderSupportingIso8601WithMicroseconds.decode(ChatSession.self, from: validJsonData)
        #expect(result.id == "session_1761441033386")
        #expect(result.messages.count == 2)
    }
}

