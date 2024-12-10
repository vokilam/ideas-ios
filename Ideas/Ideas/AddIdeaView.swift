//
//  AddIdeaView.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import SwiftUI

struct AddIdeaView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var description: String
    
    var idea: Idea?
    private let onAdd: (Idea) -> Void
    
    private init(idea: Idea?, onAdd: @escaping (Idea) -> Void = { _ in }) {
        self.idea = idea
        self.onAdd = onAdd
        
        self.title = idea?.title ?? ""
        self.description = idea?.description ?? ""
    }
    
    init (onAdd: @escaping (Idea) -> Void = { _ in }) {
        self.init(idea: nil, onAdd: onAdd)
    }
    
    init(idea: Idea) {
        self.init(idea: idea, onAdd: { _ in })
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...5) // TODO: make it work
            }
            .navigationTitle("\(idea == nil ? "Add" : "Edit") Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let idea = idea {
                            idea.title = title
                            idea.description = description
                        } else {
                            onAdd(Idea(title: title, description: description))
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
    AddIdeaView() { _ in }
}
