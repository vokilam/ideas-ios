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
    
    init(project: Project?, onAdd: @escaping (Project) -> Void = { _ in }) {
        self.project = project
        self.onAdd = onAdd
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
                        } else {
                            onAdd(Project(name: name))
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
