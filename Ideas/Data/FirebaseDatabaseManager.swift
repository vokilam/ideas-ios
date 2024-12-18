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
    
    private struct UserEntity: Decodable {
        let email: String
        let username: String
        let projects: [String: Bool]
    }
    
    private struct ProjectEntity: Decodable {
        let title: String
        let ideas: [String: IdeaEntity]
    }
    
    private struct IdeaEntity: Decodable {
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
            let ideas = project.ideas.map { (ideaId, idea) in
                Idea(
                    id: ideaId,
                    title: idea.name,
                    description: idea.description
                )
            }
            projects.append(Project(id: projectId, name: project.title, ideas: ideas))
            
        }
        return projects
    }
}

