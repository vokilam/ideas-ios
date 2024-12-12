//
//  SignInView.swift
//  Ideas
//
//  Created by Paul Malikov on 12.12.24.
//

import SwiftUI

struct SignInView: View {
    @Environment(UserManager.self) private var userManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                Spacer()
                    .frame(height: 20)
                Button {
                    Task {
                        await userManager.logIn(email: email, password: password)
                    }
                } label: {
                    Text("Sign In")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Spacer()
                    .frame(height: 20)
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Sing Up")
                        .foregroundStyle(.link)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SignInView().environment(UserManager.shared)
}
