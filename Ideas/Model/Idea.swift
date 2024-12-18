//
//  Idea.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import Foundation
import SwiftUI

@Observable
class Idea: Identifiable {
    let id: String
    var title: String
    var description: String
    let creationDate: Date
    let rating: Int
    
    init(id: String = UUID().uuidString, title: String, description: String, creationDate: Date = Date(), rating: Int = 0) {
        self.id = id
        self.title = title
        self.description = description
        self.creationDate = creationDate
        self.rating = rating
    }
}

@Observable
class Project: Identifiable {
    let id: String
    var name: String
    var ideas = [Idea]()
    let owner: String
    let collaborators: [String]?
    
    init(id: String = UUID().uuidString, name: String, owner: String, ideas: [Idea] = [], collaborators: [String]? = nil) {
        self.id = id
        self.name = name
        self.ideas = ideas
        self.owner = owner
        self.collaborators = collaborators
    }
}
