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
    
    init() {
        print("IdeasView body")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if (store.ideas.isEmpty) {
                    ContentUnavailableView(
                        "No ideas",
                        systemImage: "star",
                        description: Text("You don't have any ideas yet. Tap the + button to add one.")
                    )
                } else {
                    List {
                        ForEach(store.ideas) { idea in
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
                                    store.remove(idea: idea)
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
            .navigationTitle("Ideas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    showAddIdeaView = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddIdeaView) {
            AddIdeaView { idea in
                store.add(idea)
            }
        }
        .sheet(item: $selectedIdea) { idea in
            AddIdeaView(idea: idea)
        }
    }
}

#Preview {
    IdeasView().environment(IdeasStore.mocked)
}
