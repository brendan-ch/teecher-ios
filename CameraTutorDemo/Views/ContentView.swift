//
//  ContentView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI

struct BottomPeek<Content: View>: View {
    let peekHeight: CGFloat
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .clipped()
    }
}

struct ContentView: View {
    @State private var query = ""
    @FocusState private var keyboardFocused: Bool
    private let service = VideoCaptureService()
    var body: some View {
        ZStack(alignment: .bottom) {
            CameraPreviewView(session: service.session)
                .ignoresSafeArea()
                .onAppear {
                    VideoCaptureService.attemptAuthorization()
                    service.startRunning()
                }
                .onDisappear {
                    service.stopRunning()
                }
                .onTapGesture {
                    keyboardFocused = false
                }
                .zIndex(0)
            
                .sheet(isPresented: .constant(true)) {
                    ChatHistoryView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .clipped()
                        .background(.ultraThinMaterial)
                        .presentationDetents([.fraction(0.10), .large])
                        .presentationBackgroundInteraction(.enabled)
                        .interactiveDismissDisabled()
                }
        }
    }
}

#Preview {
    ContentView()
}
