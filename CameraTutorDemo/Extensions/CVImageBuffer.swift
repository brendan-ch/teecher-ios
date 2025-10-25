//
//  CVImageBuffer.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import CoreVideo
import VideoToolbox
import CoreImage
import ImageIO
import UniformTypeIdentifiers

extension CVImageBuffer {
    func toJpegData(quality: CGFloat = 0.8) -> Data? {
        // Create CGImage from pixel buffer
        var cgImageOut: CGImage?
        let status = VTCreateCGImageFromCVPixelBuffer(self, options: nil, imageOut: &cgImageOut)
        
        guard status == noErr, let cgImage = cgImageOut else {
            print("Failed to create CGImage, status = \(status)")
            return nil
        }
        
        let data = NSMutableData()
        guard
            let destination = CGImageDestinationCreateWithData(
                data as CFMutableData,
                UTType.jpeg.identifier as CFString,
                1,
                nil
            )
        else {
            print("Failed to create CGImageDestination")
            return nil
        }
        
        CGImageDestinationAddImage(destination, cgImage, [
            kCGImageDestinationLossyCompressionQuality: quality
        ] as CFDictionary)
        
        guard CGImageDestinationFinalize(destination) else {
            print("Failed to finalize image destination")
            return nil
        }
        
        return data as Data
    }
}
