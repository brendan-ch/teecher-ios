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
    @FocusState private var keyboardFocused: Bool

    @Environment(ChatProvider.self) private var chatProvider
    
    @State private var showingLeftSidebar = false
    @State private var showingRightSidebar = false

    @State private var baseOffset: CGFloat = 0
    @State private var offset: CGFloat = 0

    private let service = VideoCaptureService()
    
    private let sidebarWidth: CGFloat = 320
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                CameraPreviewView(session: service.session)
                    .ignoresSafeArea()
                    .onAppear {
                        VideoCaptureService.attemptAuthorization()
                        
                        Task {
                            try? await Task.sleep(for: .seconds(1))
                            service.startRunning()
                        }
                    }
                    .onDisappear {
                        service.stopRunning()
                    }
                    .onTapGesture {
                        keyboardFocused = false
                    }
                    .zIndex(0)
                
                VStack {
                    if let selectedChatSession = chatProvider.selectedChatSession {
                        RecentChatView(session: selectedChatSession)
                    }
                    
                    ChatInputBarView(keyboardFocused: $keyboardFocused) { text in
                        keyboardFocused = false
                        Task {
                            await submit(text)
                        }
                    }
                }
            }
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = baseOffset + value.translation.width
                    }
                    .onEnded { value in
                        withAnimation(.spring) {
                            let actualOffset = baseOffset + value.translation.width
                            
                            if actualOffset > 100 {
                                showingLeftSidebar = true
                                showingRightSidebar = false
                            } else if actualOffset < -100 {
                                showingRightSidebar = true
                                showingLeftSidebar = false
                            } else {
                                showingLeftSidebar = false
                                showingRightSidebar = false
                            }
                            baselineOffset()
                        }
                    }
            )
            .animation(.easeInOut, value: offset)
            .edgesIgnoringSafeArea(.all)
            
            // MARK: - Left Sidebar
            if showingLeftSidebar {
                HStack {
                    ChatHistoryView(
                        onDismiss: {
                            showingLeftSidebar = false
                            baselineOffset()
                        }
                    )
                        .frame(width: sidebarWidth)
                        .transition(.move(edge: .leading))
                    Spacer()
                }
            }
            
            // MARK: - Right Sidebar
            if showingRightSidebar {
                HStack {
                    Spacer()
                    ChatView(
                        onDismiss: {
                            showingRightSidebar = false
                            baselineOffset()
                        },
                        session: chatProvider.selectedChatSession
                    )
                        .frame(width: sidebarWidth)
                        .transition(.move(edge: .trailing))
                }
            }

        }
    }
    
    func baselineOffset() {
        offset = (showingLeftSidebar ? sidebarWidth : (showingRightSidebar ? -sidebarWidth : 0))
        baseOffset = offset
    }
    
    @MainActor
    func submit(_ query: String) async {
        // Capture the current video frame
        let capturedFrame = service.currentFrame
        guard let data = capturedFrame?.toJpegData() else {
            return
        }
        print(data)

        await chatProvider.submit(query, capturedImageData: data)
    }
}

struct SidebarView: View {
    enum Side { case left, right }
    let side: Side
    
    var body: some View {
        VStack {
            Text(side == .left ? "Left Sidebar" : "Right Sidebar")
                .font(.title)
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .foregroundColor(.white)
    }
}


#Preview {
    ContentView()
        .environment(ChatProvider())
}
