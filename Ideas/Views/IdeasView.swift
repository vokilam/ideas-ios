//
//  IdeasView.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import Foundation
import SwiftUI

struct IdeasView: View {
    
    @Environment(IdeasStore.self) private var store
    
    @State private var showAddIdeaView = false
    @State private var selectedIdea: Idea?
    
    private let project: Project
    
    init(_ project: Project) {
        self.project = project
    }
    
    var body: some View {
        
        Group {
            if (project.ideas.isEmpty) {
                ContentUnavailableView(
                    "No ideas",
                    systemImage: "star",
                    description: Text("You don't have any ideas yet. Tap the + button to add one.")
                )
            } else {
                List {
                    ForEach(project.ideas) { idea in
                        NavigationLink {
                            let _ = print("IdeasView: create details of \(idea.title)")
                            LazyView(
                                IdeaDetailsView(idea: idea)
                            )
                        } label: {
                            Text(idea.title)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                store.remove(idea, from: project)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                selectedIdea = idea
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
                
            }
        }
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {
                showAddIdeaView = true
            }) {
                Image(systemName: "plus")
            }
        }
        .fullScreenCover(isPresented: $showAddIdeaView) {
            AdditIdeaView { idea in
                store.add(idea, to: project)
            }
        }
        .fullScreenCover(item: $selectedIdea) { idea in
            AdditIdeaView(idea: idea)
        }
    }
}

#Preview {
    NavigationStack {
        IdeasView(MockData.sampleProject).environment(IdeasStore.mocked)
    }
}
