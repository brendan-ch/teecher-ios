//
//  JSONDecoder.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation

extension JSONDecoder {
    static var decoderSupportingIso8601WithMicroseconds: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)

        return decoder
    }
}
