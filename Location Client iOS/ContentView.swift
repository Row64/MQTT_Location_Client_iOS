//
//  ContentView.swift
//  Location Client iOS
//
//  Created by row64 on 9/2/26.
//

import SwiftUI

struct ContentView: View {
    
    // Login variables
    @State private var inputHost: String = ""
    @State private var inputPort: String = ""
    @State private var inputUser: String = ""
    @State private var inputPass: String = ""
    
    @State private var isPasswordVisible = false
    
    // MQTT objects
    private var login = MqLogin()
    
    // Status message variable
    @State var statusMsg: String = "Status messages appear here..."
    
    
    // ...
//    @FocusState private var hostFieldIsFocused: Bool = false
    
    
    var body: some View {
        Form {
            
            Text("Row64 Location Client")
            
            // Text fields
            // https://developer.apple.com/documentation/swiftui/textfield
            
            
            // Host field
            TextField(
                    "Host",
                    text: $inputHost
                )
//                .focused($hostFieldIsFocused)
                .onSubmit {
//                    validate(name: inputHost)
                    print(inputHost)
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            
            
            // Port field
            TextField(
                    "Port",
                    text: $inputPort
                )
//                .focused($hostFieldIsFocused)
                .onSubmit {
//                    validate(name: inputHost)
                    print(inputPort)
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
                
            
            
            // User field
            TextField(
                    "Username",
                    text: $inputUser
                )
//                .focused($hostFieldIsFocused)
                .onSubmit {
//                    validate(name: inputHost)
                    print(inputUser)
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            
            
            // Password field
            HStack {
                SecureField(
                    "Password",
                    text: $inputPass
                )
                .onSubmit {
                    

                    // ...
                    
                    
                }
                .border(.secondary)
                
                // Password reveal button
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                    }
                
                }
            
            // Password visibility
            if isPasswordVisible {
                TextField("Reveal password", text: $inputPass)
            } else {
//                SecureField("Reveal password", text: $inputPass)
            }
                
            
            // Connect button
            Button {
                
                
                // For testing text updates
//                login.logStatusMsg(msg: "Button clicked!")
                statusMsg = "(Testing) Button clicked!"
                
                
                
                
                
                // Clear any existing credential data before submitting
                // new inputs
                login.clearCredentials()
                
                // Attempt to set the credentials
                // Setting the port throws an exception if invalid
                do {
                    try login.setCredentials(
                        inputHost: inputHost,
                        inputPort: inputPort,
                        inputUser: inputUser,
                        inputPass: inputPass
                        )
                }
                catch {
                    
                    // For testing
                    print("ERROR: Bad port")
                    
//                    login.logStatusMsg(msg: "ERROR: Invalid port detected.")
                    statusMsg = "ERROR: Invalid port detected. Please input a valid port number within the range 1 to 65,535"
                    
                    // ...
                    
                }
                
                // Attempt a connection
                
                
            } label: {
                Text("Connect")
                    .padding(.all)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            
            Text(statusMsg)

            
            
        }
        .padding()
    }
    
    
    
    
    
}

#Preview {
    ContentView()
}
