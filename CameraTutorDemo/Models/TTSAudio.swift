//
//  TTSAudio.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation

struct TTSAudio: Codable {
    typealias Base64String = String
    let audio: Base64String
    
    let success: Bool
    
    init(
        session: URLSession = .shared,
        text: String
    ) async throws {
        let url: URL = .apiBaseUrl.appendingPathComponent("/api/tts")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestDictionary = [
            "text": text,
        ]
        request.httpBody = try JSONEncoder().encode(requestDictionary)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await session.data(for: request)
        self = try JSONDecoder.decoderSupportingIso8601WithMicroseconds.decode(TTSAudio.self, from: data)
    }
    
    func asData() -> Data? {
        let cleanedBase64: String
        if let range = audio.range(of: "base64,") {
            cleanedBase64 = String(audio[range.upperBound...])
        } else {
            cleanedBase64 = audio
        }
        guard let data = Data(base64Encoded: cleanedBase64) else {
            return nil
        }
        return data
    }
}
