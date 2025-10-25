//
//  VideoCaptureService.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import AVFoundation

final class VideoCaptureService: NSObject {
    /// Single-camera capture session (back camera only).
    private let captureSession = AVCaptureSession()

    /// Expose the capture session for preview layer embedding.
    var session: AVCaptureSession { captureSession }

    /// Dedicated queue for all session configuration and running state changes.
    private let sessionQueue = DispatchQueue(label: "VideoCaptureService.sessionQueue")

    /// Video output delivering CMSampleBuffers.
    private let videoDataOutput = AVCaptureVideoDataOutput()

    /// Tracks whether setup finished successfully.
    private var initialized = false

    /// Whether the user has granted capture permissions to the app.
    var isAuthorized: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status == .authorized
    }

    /// Indicates whether the capture session is running.
    var isRunning: Bool {
        return captureSession.isRunning
    }

    override init() {
        super.init()
        performSetup()
    }

    /// Attempt to request authorization for the camera.
    static func attemptAuthorization() {
        Task {
            let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
            if videoStatus == .notDetermined {
                _ = await AVCaptureDevice.requestAccess(for: .video)
            }
        }
    }

    /// Perform video capture setup for the back camera.
    private func performSetup() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }

            self.captureSession.beginConfiguration()

            // Prefer ultra-wide back camera; fall back to wide-angle back camera if unavailable.
            let backDevice = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back)
                ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

            guard let videoDeviceBack = backDevice else {
                print("Unable to get back video device")
                self.captureSession.commitConfiguration()
                return
            }

            // Configure input
            do {
                let backInput = try AVCaptureDeviceInput(device: videoDeviceBack)
                if self.captureSession.canAddInput(backInput) {
                    self.captureSession.addInput(backInput)
                } else {
                    print("Unable to add back camera input to capture session")
                }
            } catch {
                print("Error creating back camera input: \(error)")
            }

            // Configure output
            self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
            // Use 32BGRA which is common for CVPixelBuffer processing.
            self.videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

            if self.captureSession.canAddOutput(self.videoDataOutput) {
                self.captureSession.addOutput(self.videoDataOutput)
            } else {
                print("Unable to add video data output to capture session")
            }

            // Set the sample buffer delegate on a dedicated queue.
            let outputQueue = DispatchQueue(label: "VideoCaptureService.videoOutputQueue")
            self.videoDataOutput.setSampleBufferDelegate(self, queue: outputQueue)

            self.captureSession.commitConfiguration()
            self.initialized = true
        }
    }

    /// Start the capture session.
    /// Completion is called on the session queue.
    func startRunning(completion: ((Bool) -> Void)? = nil) {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            guard self.initialized else { completion?(false); return }
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
            completion?(true)
        }
    }

    /// Stop the capture session.
    /// Completion is called on the session queue.
    func stopRunning(completion: ((Bool) -> Void)? = nil) {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            guard self.initialized else { completion?(false); return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
            completion?(true)
        }
    }
}

extension VideoCaptureService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle CMSampleBuffer frames here (e.g., CVPixelBuffer processing, encoding, etc.).
        // For now, we keep it as a stub.
    }

    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Optionally handle dropped frames.
    }
}
