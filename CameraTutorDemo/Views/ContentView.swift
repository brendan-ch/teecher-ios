//
//  ContentView.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import SwiftUI
import SwiftData

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
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var keyboardFocused: Bool
    
    @State private var showingLeftSidebar = false
    @State private var showingRightSidebar = false

    @State private var baseOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    
    @State private var selectedChatSession: ChatSession? = nil

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
                    if let selectedChatSession = selectedChatSession {
                        RecentChatView(session: selectedChatSession)
                    }
                    
                    ChatInputBarView(keyboardFocused: $keyboardFocused) { text in
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
                            offset = (showingLeftSidebar ? sidebarWidth : (showingRightSidebar ? -sidebarWidth : 0))
                            baseOffset = offset
                        }
                    }
            )
            .animation(.easeInOut, value: offset)
            .edgesIgnoringSafeArea(.all)
            
            // MARK: - Left Sidebar
            if showingLeftSidebar {
                HStack {
                    ChatHistoryView(selectedChatSession: $selectedChatSession)
                        .frame(width: sidebarWidth)
                        .transition(.move(edge: .leading))
                    Spacer()
                }
            }
            
            // MARK: - Right Sidebar
            if showingRightSidebar {
                HStack {
                    Spacer()
                    ChatView(session: selectedChatSession)
                        .frame(width: sidebarWidth)
                        .transition(.move(edge: .trailing))
                }
            }

        }
    }
    
    func submit(_ query: String) async {
        // Capture the current video frame
        let capturedFrame = service.currentFrame
        guard let data = capturedFrame?.toJpegData() else {
            return
        }
        print(data)
        
        do {
            let image = Attachment(name: "image-to-be-uploaded", type: .image)
            try image.save(data: data, fileExtension: "jpg")
            
            let userChatMessage = ChatMessage(
                content: query,
                role: .user,
                timestamp: .now
            )
            userChatMessage.attachments = [image]
            
            if selectedChatSession == nil {
                selectedChatSession = ChatSession(
                    title: "New chat session",
                    createdAt: .now,
                    updatedAt: .now,
                    messages: []
                )
                modelContext.insert(selectedChatSession!)
            }
            
            guard let selectedChatSession = selectedChatSession else { return }
            selectedChatSession.messages.append(userChatMessage)
            let assistantChatMessage = try await selectedChatSession.constructChatMessageFromAssistant(userChatMessage: userChatMessage)
            selectedChatSession.messages.append(assistantChatMessage)
            
        } catch {
            print("Unable to save image: \(error)")
        }
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
    let schema = Schema([
        ChatSession.self,
        ChatMessage.self,
        Attachment.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: schema, configurations: [modelConfiguration])
    
    let chatSessionToSelect = ChatSession(
        title: "Sample chat 1",
        createdAt: .now,
        updatedAt: .now,
        messages: []
    )
    modelContainer.mainContext.insert(chatSessionToSelect)
    modelContainer.mainContext.insert(ChatSession(
        title: "Sample chat 2",
        createdAt: .now,
        updatedAt: .now,
        messages: []
    ))

    
    return ContentView()
        .modelContainer(modelContainer)
}
