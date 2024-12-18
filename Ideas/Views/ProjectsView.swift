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
                switch store.projects {
                case .idle:
                    ContentUnavailableView(
                        "No projects",
                        systemImage: "star",
                        description: Text("You don't have any projects yet. Tap the + button to create one.")
                    )
                case .loading:
                    ProgressView()
                        .controlSize(.extraLarge)
                case .failure(let error):
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                case .success(let projects):
                    if projects.isEmpty {
                        ContentUnavailableView(
                            "No projects",
                            systemImage: "star",
                            description: Text("You don't have any projects yet. Tap the + button to create one.")
                        )
                    } else {
                        List(projects) { project in
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
                        .refreshable {
                            await store.loadProjects()
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
            .onAppear {
                print("Group onAppear")
            }
            .onDisappear {
                print("Group onDisappear")
            }
            .task {
                print("loadProjects()")
                await store.loadProjects()
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
