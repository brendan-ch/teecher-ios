//
//  Attachment.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//
import Foundation

struct Attachment: Identifiable, Equatable {
    enum AttachmentType: String, Codable {
        case image, file, audio, video, link, other
    }
    
    let id: String
    var name: String
    var type: AttachmentType
    var relativePath: String?
    var mimeType: String?
    var size: Int?
    var thumbnailData: Data?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        type: AttachmentType,
        relativePath: String? = nil,
        mimeType: String? = nil,
        size: Int? = nil,
        thumbnailData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.relativePath = relativePath
        self.mimeType = mimeType
        self.size = size
        self.thumbnailData = thumbnailData
    }
    
    var fileURL: URL? {
        guard let relativePath else { return nil }
        return Self.documentsDirectory.appendingPathComponent(relativePath)
    }
    
    mutating func save(data: Data, fileExtension: String? = nil) throws {
        let ext = fileExtension ?? (mimeType.flatMap { Self.preferredExtension(for: $0) } ?? "dat")
        let filename = "\(id).\(ext)"
        let url = Self.documentsDirectory.appendingPathComponent(filename)
        
        try data.write(to: url)
        relativePath = filename
        size = data.count
    }
    
    func loadData() throws -> Data? {
        guard let fileURL else { return nil }
        return try Data(contentsOf: fileURL)
    }
    
    mutating func deleteFile() throws {
        guard let fileURL else { return }
        try FileManager.default.removeItem(at: fileURL)
        relativePath = nil
    }
    
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
