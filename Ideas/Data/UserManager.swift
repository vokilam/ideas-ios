//
//  UserManager.swift
//  Ideas
//
//  Created by Paul Malikov on 12.12.24.
//

import FirebaseAuth

@Observable
class UserManager {
    static let shared = UserManager()
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    private init() {
        self.currentUser = Auth.auth().currentUser
        authHandle = Auth.auth().addStateDidChangeListener { auth, user in
            self.currentUser = user
        }
    }
    
    deinit {
        if let authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    private(set) var currentUser: User?
    
    var isAuthenticated: Bool {
        return currentUser != nil
    }
    
    var currentUserId: String? {
        return currentUser?.uid
    }

    func signUp(email: String, password: String) async -> Result<User, Error> {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return .success(authResult.user)
        } catch {
            return .failure(error)
        }
    }
    
    func logIn(email: String, password: String) async -> Result<User, Error> {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return .success(authResult.user)
        } catch {
            return .failure(error)
        }
    }
    
    func logOut() async -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
