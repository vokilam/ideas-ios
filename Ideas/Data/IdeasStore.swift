//
//  IdeasStore.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import Foundation

@Observable
class IdeasStore {
    private(set) var projects: LoadableProject = .idle
    
    private let databaseManager = FirebaseDatabaseManager.shared
    
    func add(_ project: Project) async -> Void {
        guard case .success = self.projects else { return }
        
        do {
            try await databaseManager.createProject(project)
            await loadProjects()
        } catch {
            print(error)
        }
    }
    
    func update(_ project: Project) async -> Void {
        guard case .success = self.projects else { return }
        
        do {
            try await databaseManager.updateProject(project)
            await loadProjects()
        } catch {
            print(error)
        }
    }
    
    func remove(_ project: Project) {
        guard case .success(var projects) = self.projects else { return }
        projects.removeAll(where: { $0.id == project.id })
    }
    
    func add(_ idea: Idea, to project: Project) {
        guard case .success(let projects) = self.projects else { return }
        projects.first(where: { $0.id == project.id })?.ideas.append(idea)
    }
    
    func remove(_ idea: Idea, from project: Project) {
        guard case .success(let projects) = self.projects else { return }
        projects.first(where: { $0.id == project.id })?.ideas.removeAll(where: { $0.id == idea.id })
    }
    
    func loadProjects() async -> Void {
        do {
            self.projects = if case .success = self.projects { self.projects } else { .loading }
            
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let projects = try await databaseManager.fetchProjects()
            self.projects = .success(projects)
        } catch {
            print(error)
            self.projects = .failure(error)
        }
    }
}

enum LoadableProject {
    case idle
    case loading
    case success([Project])
    case failure(Error)
}

extension IdeasStore {
    static let mocked = {
        let store = IdeasStore()
        store.projects = .success(MockData.projects)
        return store
    }()
}
