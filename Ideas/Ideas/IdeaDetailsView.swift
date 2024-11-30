//
//  IdeaView.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import SwiftUI

struct IdeaDetailsView: View {
    
    // TODO: although we do not mutate `idea` property, it is defined as binding because we want to get updates of this property when it is edited from AddIdeaView
    @Binding var idea: Idea
    @State private var editableIdea: Idea?
    
    init(idea: Binding<Idea>) {
        self._idea = idea
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
        IdeaDetailsView(idea: .constant(MockData.sampleIdea))
    }
}
