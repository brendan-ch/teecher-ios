//
//  ContentView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct ContentView: View {
    private let service = VideoCaptureService()

    var body: some View {
        CameraPreviewView(session: service.session)
            .ignoresSafeArea()
            .onAppear {
                VideoCaptureService.attemptAuthorization()
                service.startRunning()
            }
            .onDisappear {
                service.stopRunning()
            }
    }
}

#Preview {
    ContentView()
}
