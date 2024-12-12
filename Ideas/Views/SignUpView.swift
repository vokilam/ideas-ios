//
//  SignInView.swift
//  Ideas
//
//  Created by Paul Malikov on 12.12.24.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(UserManager.self) private var userManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
            Spacer()
                .frame(height: 20)
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button {
                Task {
                    let result = await userManager.signUp(email: email, password: password)
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("Sign Up")
            }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(
                    email.isEmpty || password.isEmpty || (password != confirmPassword)
                )
        }
        .padding()
    }
}

#Preview {
    SignUpView()
}
