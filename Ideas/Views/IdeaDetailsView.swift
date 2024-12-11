//
//  IdeaView.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import SwiftUI

struct IdeaDetailsView: View {
    
    private let idea: Idea
    @State private var shouldEditIdea = false
    
    init(idea: Idea) {
        self.idea = idea
        print("IdeaDetailsView body")
    }
    
    var body: some View {
        List {
            Section {
                Text(idea.title)
                Text(idea.description)
            } header: {
                Text("Description")
            }
        }
        .navigationTitle(idea.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shouldEditIdea = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $shouldEditIdea) {
            AdditIdeaView(idea: idea)
        }
    }
}

#Preview {
    NavigationStack {
        IdeaDetailsView(idea: MockData.sampleIdea)
    }
}
