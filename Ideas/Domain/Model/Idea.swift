//
//  Idea.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import Foundation

struct Idea: Identifiable {
    let id: String
    let title: String
    let description: String
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
