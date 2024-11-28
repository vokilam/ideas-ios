//
//  AddIdeaView.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import SwiftUI

struct AddIdeaView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(IdeasStore.self) private var store
    
    @State private var title: String
    @State private var description: String
    
    let idea: Idea?
    
    init(idea: Idea?) {
        self.idea = idea
        if let idea = idea {
            self.title = idea.title
            self.description = idea.description
        } else {
            self.title = ""
            self.description = ""
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...5) // TODO: make it work
            }
            .navigationTitle("Add Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let idea = idea {
                            if let index = store.ideas.firstIndex(where: { $0.id == idea.id }) {
                                store.ideas[index] = Idea(
                                    id: idea.id,
                                    title: title,
                                    description: description,
                                    creationDate: idea.creationDate,
                                    rating: idea.rating
                                )
                            }
                        } else {
                            store.ideas.append(Idea(title: title, description: description))
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddIdeaView(idea: nil).environment(IdeasStore())
}
