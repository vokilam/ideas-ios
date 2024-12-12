//
//  RootView.swift
//  Ideas
//
//  Created by Paul Malikov on 12.12.24.
//

import SwiftUI

struct RootView: View {
    @Environment(UserManager.self) private var userManager
    
    var body: some View {
        Group {
            if let _ = userManager.currentUser {
                ProjectsView()
            } else {
                SignInView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: userManager.isAuthenticated)
    }
}

#Preview {
    RootView()
        .environment(IdeasStore.mocked)
        .environment(UserManager.shared)
}
