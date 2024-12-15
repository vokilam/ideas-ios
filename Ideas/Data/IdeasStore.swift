//
//  IdeasStore.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import Foundation

@Observable
class IdeasStore {
    private(set) var projects = [Project]()
    
    private let databaseManager = FirebaseDatabaseManager.shared
    
    func add(_ project: Project) {
        projects.append(project)
    }
    
    func remove(_ project: Project) {
        projects.removeAll(where: { $0.id == project.id })
    }
    
    func add(_ idea: Idea, to project: Project) {
        projects.first(where: { $0.id == project.id })?.ideas.append(idea)
    }
    
    func remove(_ idea: Idea, from project: Project) {
        projects.first(where: { $0.id == project.id })?.ideas.removeAll(where: { $0.id == idea.id })
    }
    
    func loadProjects() async -> Void {
        do {
            projects = try await databaseManager.fetchProjects()
        } catch {
            print(error)
        }
        
    }
}

extension IdeasStore {
    static let mocked = {
        let store = IdeasStore()
        store.projects = MockData.projects
        return store
    }()
}
