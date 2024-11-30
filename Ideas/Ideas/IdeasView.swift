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
    
    init() {
        print("IdeasView body")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if (store.ideas.isEmpty) {
                    ContentUnavailableView("No ideas", systemImage: "star", description: Text("You don't have any ideas yet. Tap the + button to add one."))
                } else {
                    List {
                        ForEach(store.ideas) { idea in
                            NavigationLink {
                                LazyView(
                                    IdeaDetailsView(idea: .constant(idea))
                                )
                            } label: {
                                Text(idea.title)
                            }
                        }
                        .onDelete { indexSet in
                            store.ideas.remove(atOffsets: indexSet)
                        }
                    }
                    
                }
            }
            .navigationTitle("Ideas")
            .toolbar {
                Button(action: {
                    showAddIdeaView = true
                }) {
                    Image(systemName: "plus")
                }
                
                EditButton()
            }
        }
        .sheet(isPresented: $showAddIdeaView) {
            AddIdeaView(idea: nil)
        }
    }
}

#Preview {
    IdeasView().environment(IdeasStore.mocked)
}
