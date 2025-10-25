//
//  Attachment.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import SwiftData

@Model
final class Attachment {
    enum AttachmentType: String, Codable {
        case image, file, audio, video, link, other
    }
    
    var id = UUID()
    var name: String
    var type: AttachmentType
    var relativePath: String? // relative to Documents directory
    var mimeType: String?
    var size: Int?
    var thumbnailData: Data?
    
    @Relationship(inverse: \ChatMessage.attachments)
    var message: ChatMessage?
    
    init(
        name: String,
        type: AttachmentType,
        relativePath: String? = nil,
        mimeType: String? = nil,
        size: Int? = nil,
        thumbnailData: Data? = nil
    ) {
        self.name = name
        self.type = type
        self.relativePath = relativePath
        self.mimeType = mimeType
        self.size = size
        self.thumbnailData = thumbnailData
    }
    
    // MARK: - Computed URLs
    
    var fileURL: URL? {
        guard let relativePath else { return nil }
        return Self.documentsDirectory.appendingPathComponent(relativePath)
    }
    
    // MARK: - File operations
    
    func save(data: Data, fileExtension: String? = nil) throws {
        let ext = fileExtension ?? (mimeType.flatMap { Self.preferredExtension(for: $0) } ?? "dat")
        let filename = "\(id.uuidString).\(ext)"
        let url = Self.documentsDirectory.appendingPathComponent(filename)
        
        try data.write(to: url)
        self.relativePath = filename
        self.size = data.count
    }
    
    func loadData() throws -> Data? {
        guard let fileURL else { return nil }
        return try Data(contentsOf: fileURL)
    }
    
    func deleteFile() throws {
        guard let fileURL else { return }
        try FileManager.default.removeItem(at: fileURL)
        relativePath = nil
    }
    
    // MARK: - Static helpers
    
    private static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private static func preferredExtension(for mimeType: String) -> String? {
        switch mimeType {
        case "image/png": return "png"
        case "image/jpeg": return "jpg"
        case "video/mp4": return "mp4"
        case "audio/mpeg": return "mp3"
        default: return nil
        }
    }
}
