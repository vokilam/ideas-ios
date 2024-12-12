//
//  ProjectsView.swift
//  Ideas
//
//  Created by Paul Malikov on 11.12.24.
//

import SwiftUI

struct ProjectsView: View {
    @Environment(IdeasStore.self) private var store
    @Environment(UserManager.self) private var userManager
    
    @State private var showAddProjectView = false
    @State private var showUserView = false
    @State private var selectedProject: Project?
    
    var body: some View {
        NavigationStack {
            Group {
                if store.projects.isEmpty {
                    ContentUnavailableView(
                        "No projects",
                        systemImage: "star",
                        description: Text("You don't have any projects yet. Tap the + button to create one.")
                    )
                } else {
                    List(store.projects) { project in
                        NavigationLink {
                            LazyView(IdeasView(project))
                        } label: {
                            Text(project.name)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                store.remove(project)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                selectedProject = project
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Projects")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    showAddProjectView = true
                }) {
                    Image(systemName: "plus")
                }
                
                Button(action: {
                    showUserView.toggle()
                }) {
                    Image(systemName: "person")
                }
            }
        }
        .fullScreenCover(isPresented: $showAddProjectView) {
            AdditProjectView(onAdd: store.add)
        }
        .fullScreenCover(item: $selectedProject) { project in
            AdditProjectView(project: project)
        }
        .sheet(isPresented: $showUserView) {
            VStack {
                Text("User View")
                    .font(.largeTitle)
                Button("Log out") {
                    Task {
                        await userManager.logOut()
                    }
                }
            }
        }
    }
}

#Preview {
    ProjectsView()
        .environment(IdeasStore.mocked)
        .environment(UserManager.shared)
}
