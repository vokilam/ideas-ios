//
//  AdditProjectView.swift
//  Ideas
//
//  Created by Paul Malikov on 11.12.24.
//

import SwiftUI

struct AdditProjectView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    
    let project: Project?
    private let onAdd: (Project) -> Void
    private let onEdit: (Project) -> Void
    
    init(project: Project?, onAdd: @escaping (Project) -> Void = { _ in }, onEdit: @escaping (Project) -> Void = { _ in }) {
        self.project = project
        self.onAdd = onAdd
        self.onEdit = onEdit
        self.name = project?.name ?? ""
    }
    
    init(onAdd: @escaping (Project) -> Void = { _ in }) {
        self.init(project: nil, onAdd: onAdd)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
            }
            .navigationTitle(project?.name ?? "New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let project {
                            project.name = name
                            onEdit(project)
                        } else {
                            onAdd(Project(name: name, owner: "userId1"))
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty)
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
    
    AdditProjectView(project: nil)
}
