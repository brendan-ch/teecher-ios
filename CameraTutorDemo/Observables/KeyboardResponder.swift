//
//  KeyboardResponder.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import SwiftUI
import Combine

// Approach taken from https://dev.to/mrcflorian/managing-the-keyboard-in-swiftui-a-comprehensive-tutorial-11p0
final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0 {
        willSet {
            print("Setting \(Date.now)")
        }
    }
    
    var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    
    init() {
        print("Initializing keyboard responder")
        keyboardWillShowNotification.map { notification in
            CGFloat((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0)
        }
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)
        
        keyboardWillHideNotification.map { _ in
            CGFloat(0)
        }
        .assign(to: \.currentHeight, on: self)
        .store(in: &cancellableSet)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
}
