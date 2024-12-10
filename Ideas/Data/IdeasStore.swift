//
//  IdeasStore.swift
//  Ideas
//
//  Created by Paul Malikov on 28.11.24.
//

import Foundation

@Observable
class IdeasStore {
    var ideas = [Idea]()
    
    func add(_ idea: Idea) {
        ideas.append(idea)
    }
    
    func remove(atOffset offset: IndexSet) {
        ideas.remove(atOffsets: offset)
    }
}

extension IdeasStore {
    static let mocked = {
        let store = IdeasStore()
        store.ideas = MockData.ideas
        return store
    }()
}
