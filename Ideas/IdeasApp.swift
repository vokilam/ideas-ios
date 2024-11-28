//
//  IdeasApp.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import SwiftUI

@main
struct IdeasApp: App {
    
    @State private var store = IdeasStore()
    
    var body: some Scene {
        WindowGroup {
            IdeasView()
        }.environment(store)
    }
}
