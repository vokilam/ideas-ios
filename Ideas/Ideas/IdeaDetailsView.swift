//
//  IdeaView.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import SwiftUI

private let mockData = Idea(title: "Remove background from photo", description: "Remove background from photo using AI Remove background from photo using AI")

struct IdeaDetailsView: View {
    
    @Binding var idea: Idea
    @State private var editableIdea: Idea?
    
    init(idea: Binding<Idea>) {
        self._idea = idea
        print("IdeaDetailsView body")
    }
    
    var body: some View {
        List {
            Text(idea.description)
        }
        .navigationTitle(idea.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editableIdea = idea
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(item: $editableIdea) { idea in
            AddIdeaView(idea: idea)
        }
    }
}

#Preview {
    NavigationStack {
        IdeaDetailsView(idea: .constant(mockData))
    }
}
