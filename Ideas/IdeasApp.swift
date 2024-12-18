//
//  IdeasApp.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct IdeasApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var store = IdeasStore()
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environment(store)
        .environment(UserManager.shared)
    }
}
