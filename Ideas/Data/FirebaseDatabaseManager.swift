//
//  FirebaseDabaseManager.swift
//  Ideas
//
//  Created by Paul Malikov on 15.12.24.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

// Reltime database structure
// {
//   "users": {
//     "userId1": {
//       "username": "JohnDoe",
//       "email": "johndoe@example.com",
//       "projects": {
//         "projectId1": true,
//         "projectId2": true
//       }
//     }
//   },
//   "projects": {
//     "projectId1": {
//       "title": "Project 1",
//       "owner": "userId1",
//       "collaborators": {
//         "userId2": true
//       },
//       "ideas": {
//         "ideaId1": {
//           "name": "Idea 1",
//           "description": "This is the first idea."
//         }
//       }
//     }
// }
class FirebaseDatabaseManager {
    static let shared = FirebaseDatabaseManager()
    
    enum DatabaseError: Error {
        case invalidData
    }
    
    private struct UserEntity: Codable {
        let email: String
        let username: String
        let projects: [String: Bool]
    }
    
    private struct ProjectEntity: Codable {
        let title: String
        let owner: String
        let ideas: [String: IdeaEntity]?
        let collaborators: [String: Bool]?
        
        init(title: String, owner: String, ideas: [String : IdeaEntity]?, collaborators: [String : Bool]? = nil) {
            self.title = title
            self.owner = owner
            self.ideas = ideas
            self.collaborators = collaborators
        }
    }
    
    private struct IdeaEntity: Codable {
        let name: String
        let description: String
    }
    
    private init() {}
    
    func fetchProjects() async throws -> [Project] {
        let dbRef = Database.database().reference()
//        guard let userId = Auth.auth().currentUser?.uid else { return [] }
        let userId = "userId1"
        let userRef = dbRef.child("users").child(userId)
        let userSnapshot = try await userRef.getData()
        
        let user = try userSnapshot.data(as: UserEntity.self)
        
        // Fetch details of each project
        var projects: [Project] = []
        for projectId in user.projects.keys {
            let projectRef = dbRef.child("projects").child(projectId)
            let projectSnapshot = try await projectRef.getData()
            
            let project = try projectSnapshot.data(as: ProjectEntity.self)
            let ideas = project.ideas?.map { (ideaId, idea) in
                Idea(
                    id: ideaId,
                    title: idea.name,
                    description: idea.description
                )
            } ?? []
            projects.append(
                Project(
                    id: projectId,
                    name: project.title,
                    owner: project.owner,
                    ideas: ideas,
                    collaborators: project.collaborators?.keys.map { $0 }
                )
            )
            
        }
        return projects
    }
    
    func createProject(_ project: Project) async throws {
        let dbRef = Database.database().reference()
        let projectId = project.id
        let projectRef = dbRef.child("projects").child(projectId)
    
        let projectDict = mapProject(project).dictionary
        try await projectRef.setValue(projectDict)
        
        let userId = "userId1"
        let userProjectsRef = dbRef.child("users").child(userId).child("projects").child(projectId)
        try await userProjectsRef.setValue(true)
    }
    
    func updateProject(_ project: Project) async throws {
        let dbRef = Database.database().reference()
        let projectId = project.id
        let projectRef = dbRef.child("projects").child(projectId)
    
        try await projectRef.setValue(mapProject(project).dictionary)
    }

    private func mapProject(_ project: Project) -> ProjectEntity {
        let ideas = project.ideas.map { (idea) in
            (idea.id, IdeaEntity(name: idea.title, description: idea.description))
        }
        // map collaborators
        let collaborators = project.collaborators?.map { ($0, true) } ?? []
        return ProjectEntity(
            title: project.name,
            owner: project.owner,
            ideas: Dictionary(uniqueKeysWithValues: ideas),
            collaborators: Dictionary(uniqueKeysWithValues: collaborators)
        )
    }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}


