//
//  ContentView.swift
//  Location Client iOS
//
//  Created by row64 on 9/2/26.
//

import SwiftUI
import CocoaMQTT

struct ContentView: View {
    
    // Login variables
    @State private var inputHost: String = ""
    @State private var inputPort: String = ""
    @State private var inputUser: String = ""
    @State private var inputPass: String = ""
    
    @State private var isPasswordVisible = false
    
    
    // MQTT objects
    private var login = MqLogin()
    @State private var client = MqClient()

    
    // Location object
    private var location = LocationManager()
//    @State private var location: LocationManager
    
    
    // Status message variable
    @State public var statusMsg: String = "Status messages appear here..."
    
    
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
                
                print("Connect button clicked") // For testing
                
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
                catch MqCredentialsError.missingRequired {
                    statusMsg = "ERROR: Host and port are required. Additionally provide a username and password if your broker requires authentication."
                    return
                }
                catch MqCredentialsError.badPort {
                    statusMsg = "ERROR: Invalid port detected. Please input a valid port number within the range 1 to 65,535"
                    return
                }
                catch {
                    statusMsg = "ERROR: Unexpected credential error"
                    return

                }
                
                // Assign login to MQTT client
                client.setLogin(mqLogin: login)
                
                client.setView(v: self)
                
//                client.initializeLogin(mqLogin: login)
//                client.initializeMqtt3Client(login: login)
//                client.initializeMqtt5Client(login: login)
                
                // Attempt to establish a connection
//                statusMsg = "Attempting to connect..."
                client.connectToBroker()
                

                // FOR TESTING
                // This works
//                _ = mqManager.mqtt.connect()
                
                
                
            } label: {
                Text("Connect")
                    .padding(.all)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            
            
            
            
            
            
            
            // Location updates button
            Button {
//                location = LocationManager()
                location.startLocationUpdates()
                
            } label: {
                Text("Send location updates")
                    .padding(.all)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
            
            
            
            
            
            
            // System message output text field
            Text(statusMsg)

            
            
        }
        .padding()
    }
    
    
}

#Preview {
    ContentView()
}
